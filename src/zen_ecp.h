/* This file is part of Zenroom (https://zenroom.dyne.org)
 *
 * Copyright (C) 2017-2025 Dyne.org foundation
 * designed, written and maintained by Denis Roio <jaromil@dyne.org>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 */

#ifndef __ZEN_ECP_H__
#define __ZEN_ECP_H__

#include <zen_octet.h>
#include <zen_ecp_factory.h>
#include <hedley.h>

typedef struct {
	size_t halflen; // length in bytes of a reduced coordinate
	int totlen; // length of a serialized octet
	ECP  val;
	int ref;
	// TODO: the values above make it necessary to propagate the
	// visibility on the specific curve point types to the rest of the
	// code. To abstract these and have get/set functions may save a
	// lot of boilerplate when implementing support for multiple
	// curves ECP.
} ecp;

HEDLEY_NON_NULL(1)
void ecp_free(lua_State *L, HEDLEY_NO_ESCAPE const ecp* e);

HEDLEY_NON_NULL(1)
HEDLEY_WARN_UNUSED_RESULT
ecp* ecp_new(lua_State *L);

HEDLEY_NON_NULL(1)
HEDLEY_WARN_UNUSED_RESULT
const ecp* ecp_arg(lua_State *L,int n);

typedef struct {
	size_t halflen;
	size_t totlen;
	ECP2  val;
	int ref;
	// TODO: the values above make it necessary to propagate the
	// visibility on the specific curve point types to the rest of the
	// code. To abstract these and have get/set functions may save a
	// lot of boilerplate when implementing support for multiple
	// curves ECP.
} ecp2;

void ecp2_free(lua_State *L, HEDLEY_NO_ESCAPE const ecp2* e);

HEDLEY_NON_NULL(1)
HEDLEY_WARN_UNUSED_RESULT
ecp2* ecp2_new(lua_State *L);

HEDLEY_NON_NULL(1)
HEDLEY_WARN_UNUSED_RESULT
const ecp2* ecp2_arg(lua_State *L,int n);

char gf_sign(BIG y);
char gf2_sign(BIG y0, BIG y1);

#endif
