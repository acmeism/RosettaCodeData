#include <lua.h>
#include <lualib.h>
#include <lauxlib.h>

#include <stdio.h>
#include <stdlib.h>

const char * const lua_code = "print('tau = ' .. 8*math.atan(1))";

int
main(void)
{
	lua_State* L;

	/* initialize lua */
	L = luaL_newstate();
	luaL_openlibs(L); /* allows use of lua's standard libraries e.g. math */

	/* load and run the code */
	if (luaL_loadstring(L, lua_code) != LUA_OK) {
		fprintf(stderr, "Error loading lua code\n");
		return EXIT_FAILURE;
	}

	if (lua_pcall(L, 0, 0, 0) != LUA_OK) {
		fprintf(stderr, "Error running lua code\n");
		return EXIT_FAILURE;
	}

	/* tidy up */
	lua_pop(L, lua_gettop(L));
	lua_close(L);

	return 0;
}
