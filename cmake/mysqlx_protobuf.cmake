# Copyright (c) 2015, 2016, Oracle and/or its affiliates. All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

include(FindProtobuf)

IF(MSVC)
  SET(MYSQLX_PROTOBUF_MSVC_DISABLED_WARNINGS "/wd4267 /wd4244")
ENDIF()

# Standard PROTOBUF_GENERATE_CPP modified to generate both
# protobuf and protobuf-lite C++ files.
FUNCTION(MYSQLX_PROTOBUF_GENERATE_CPP SRCS HDRS)
  IF(NOT ARGN)
    MESSAGE(SEND_ERROR
      "Error: MYSQLX_PROTOBUF_GENERATE_CPP() called without any proto files")
    RETURN()
  ENDIF()

  SET(${SRCS})
  SET(${HDRS})
  FOREACH(FIL ${ARGN})
    GET_FILENAME_COMPONENT(ABS_FIL ${FIL} ABSOLUTE)
    GET_FILENAME_COMPONENT(FIL_WE ${FIL} NAME_WE)

    LIST(APPEND ${SRCS} "${CMAKE_BINARY_DIR}/generated/protobuf/${FIL_WE}.pb.cc")
    LIST(APPEND ${HDRS} "${CMAKE_BINARY_DIR}/generated/protobuf/${FIL_WE}.pb.h")

    ADD_CUSTOM_COMMAND(
      OUTPUT "${CMAKE_BINARY_DIR}/generated/protobuf/${FIL_WE}.pb.cc"
             "${CMAKE_BINARY_DIR}/generated/protobuf/${FIL_WE}.pb.h"
      COMMAND ${CMAKE_COMMAND}
            -E make_directory "${CMAKE_BINARY_DIR}/generated/protobuf"
      COMMAND ${PROTOBUF_PROTOC_EXECUTABLE}
      ARGS --cpp_out=dllexport_decl=X_PROTOCOL_API:${CMAKE_BINARY_DIR}/generated/protobuf
           -I "${CMAKE_SOURCE_DIR}/src/x_protocol/proto" ${ABS_FIL}
      DEPENDS ${ABS_FIL} ${PROTOBUF_PROTOC_EXECUTABLE}
      COMMENT "Running C++ protocol buffer compiler on ${FIL}"
      VERBATIM)
  ENDFOREACH()

  SET_SOURCE_FILES_PROPERTIES(
    ${${SRCS}} ${${HDRS}}
    PROPERTIES GENERATED TRUE)
  
  IF(MSVC)
    ADD_COMPILE_FLAGS(${${SRCS}} 
      COMPILE_FLAGS ${MYSQLX_PROTOBUF_MSVC_DISABLED_WARNINGS})
  ENDIF()
  
  SET(${SRCS} ${${SRCS}} PARENT_SCOPE)
  SET(${HDRS} ${${HDRS}} PARENT_SCOPE)
ENDFUNCTION()

