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

#include <stdlib.h>
#include <errno.h>

#include <zen_error.h>
#include <lua.h>
#include <zenroom.h>

extern void *ZMM;
extern void *sfpool_malloc (void *restrict opaque, const size_t size);
extern void  sfpool_free   (void *restrict opaque, void *ptr);
extern void *sfpool_realloc(void *restrict opaque, void *ptr, const size_t size);

/**
 * Implementation of the memory allocator for the Lua state.
 *
 * See: http://www.lua.org/manual/5.3/manual.html#lua_Alloc
 *
 * @param ud User Data Pointer
 * @param ptr Pointer to the memory block being allocated/reallocated/freed.
 * @param osize The original size of the memory block.
 * @param nsize The new size of the memory block.
 *
 * @return void* A pointer to the memory block.
 */
void *sfpool_memory_manager(void *ud, void *ptr, size_t osize, size_t nsize) {
  (void)ud;
	if(ptr == NULL) {
		// When ptr is NULL, osize encodes the kind of object that Lua
		// is allocating. osize is any of LUA_TSTRING, LUA_TTABLE,
		// LUA_TFUNCTION, LUA_TUSERDATA, or LUA_TTHREAD when (and only
		// when) Lua is creating a new object of that type. When osize
		// is some other value, Lua is allocating memory for something
		// else.
		if(nsize!=0) {
			void *ret;
			if(osize==LUA_TUSERDATA)
				ret = sfpool_malloc(ZMM, nsize);
			else
				ret = malloc(nsize);
			if(ret) return ret;
			zerror(NULL, "Malloc out of memory, requested %lu B", nsize);
			return NULL;
		} else return NULL;

	} else {
		// When ptr is not NULL, osize is the size of the block
		// pointed by ptr, that is, the size given when it was
		// allocated or reallocated.
		if(nsize==0) {
			// When nsize is zero, the allocator must behave like free
			// and return NULL.
			sfpool_free(ZMM, ptr);
			return NULL; }

		// When nsize is not zero, the allocator must behave like
		// realloc. The allocator returns NULL if and only if it
		// cannot fulfill the request. Lua assumes that the allocator
		// never fails when osize >= nsize.
		return sfpool_realloc(ZMM, ptr, nsize);
	}
}

void *sys_memory_manager(void *ud, void *ptr, size_t osize, size_t nsize) {
	(void)ud;
	if(ptr == NULL) {
		if(nsize!=0) {
			void *ret = malloc(nsize);
			if(ret) return ret;
			zerror(NULL, "Malloc out of memory, requested %lu B", nsize);
			return NULL;
		} else return NULL;

	} else {
		if(nsize==0) {
			free(ptr);
			return NULL; }
		return realloc(ptr, nsize);
	}
}
