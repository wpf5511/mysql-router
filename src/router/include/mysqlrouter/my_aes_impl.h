/*
  Copyright (c) 2014, 2017, Oracle and/or its affiliates. All rights reserved.

  This program is free software; you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation; version 2 of the License.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program; if not, write to the Free Software
  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/

/** Maximum supported key length */
#define MAX_AES_KEY_LENGTH 256

/* TODO: remove in a future version */
/* Guard against using an old export control restriction #define */
#ifdef AES_USE_KEY_BITS
#error AES_USE_KEY_BITS not supported
#endif

namespace myaes {

extern uint32_t *my_aes_opmode_key_sizes;


void my_aes_create_key(const unsigned char *key, uint32_t key_length,
                       uint8_t *rkey, enum my_aes_opmode opmode);
}
