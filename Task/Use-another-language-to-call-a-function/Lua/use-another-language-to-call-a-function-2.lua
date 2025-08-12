/* Query_lua.c */
#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <string.h>

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

// tell lua how many args for a function
typedef enum { NOARG, ONEARG, TWOARGS, THREEARGS } argcount;
//              0     1       2        3

// diagnostics when things go wrong
typedef enum { C_OK, C_FAILURE, LUA_FAILURE} exitcode;
//             0     1          2

/* lua vars we will create or use */
const char* lua_Query    = "Query";
const char* lua_Data     = "Data";
const char* lua_qdb_init = "qdb_init";
const char* lua_qdb      = "qdb";
const char* lua_response = "lua_response";


int LTop; // global  C index to top of lua stack

/* function prototypes */

int Query(char* Data, size_t * Length);

void fail(const char* fmsg, const char* errstr, exitcode ret);

lua_State* C_lua_init(const char*  luafile);

bool C_push_string(lua_State* L, const char* name,
		   const char* str, const size_t n);

bool C_get_string( lua_State * L, const char* src,
		   char* dest, size_t max);


// exit program with diagnostice and exitcode
void fail(const char* fmsg, const char* errstr, exitcode ret) {

  fprintf(stderr, "%s ", fmsg);

  if (errstr != NULL){ fprintf(stderr, "%s ", errstr); }

  fprintf(stderr, "\n");

  exit(ret);
}


// push C string to lua
bool C_push_string(lua_State* L, const char* name,
		   const char* str, const size_t n){
  (void) n;
  lua_pushstring(L, str);
  lua_setglobal(L, name);
  return true;
}

// get C string from lua string by variable var
bool C_get_string( lua_State * L, const char* luavar,
		   char* dest, size_t max){

  const char* lstring = NULL;
  size_t len = 0;

  lua_getglobal(L, luavar);

  if(!lua_isstring(L, -1)) {
    fail("expected a string", lua_tostring(L, -1), LUA_FAILURE);
  }

  LTop = lua_gettop(L);

  lstring = lua_tolstring(L, LTop, &max );
  len =  strlen(lstring);

  if (len > 0) {
    strncpy(dest, lstring, len);
    dest[len+1] = '\0';
    return true;
  }

  return false;
}


/*
  initialize the lua vm
  load up the lua file
  any commands in the global area will run
*/

lua_State* C_lua_init(const char*  luafile) {

  exitcode status = C_OK;

  /// creates Lua machine & env
  lua_State* L = luaL_newstate();
  if (L == NULL) {
    fail("could not create lua state", "lua internal failure", LUA_FAILURE);
  }

  // imports basic libs like string, io, os, table, utf-8, math
  luaL_openlibs(L);

  // lua file to load
  status = luaL_loadfile(L, luafile);

  if (status != LUA_OK){
    fail("loadfile failed",  lua_tostring(L, -1), LUA_FAILURE);
  }

  /* "priming run"
      SEE http://www.troubleshooters.com/codecorn/lua/lua_c_calls_lua.htm
  */
  if (lua_pcall(L, 0, 0, 0) != LUA_OK) {
    fail("priming run failed",lua_tostring(L, -1), LUA_FAILURE);
  }

  return L;
}

/* --------------------------------------------------
   function called by main in Query.c
*/

int Query(char* Data, size_t * Length) {

  /* ======= SETUP LUA ====== */
  // create Lua vm with file
  lua_State* L = C_lua_init("Query.lua");

  // call db init
  lua_getglobal(L, lua_qdb_init);
  luaL_checktype(L, -1, LUA_TFUNCTION); // optionally check lua type

  int result = lua_pcall(L, NOARG, 0, 0); // execute lua func
  if (result != LUA_OK) {
    fail("failed to run qdb_init function", lua_tostring(L, -1), LUA_FAILURE);
  }

  /* ======= RUN LUA CODE ========= */

  // put Data into Lua env as a string
  C_push_string(L, lua_Data, Data, *Length-1);

  /* set function to call and 1 arg(s) */
  lua_getglobal(L, lua_Query); // function
  luaL_checktype(L, -1, LUA_TFUNCTION);

  lua_getglobal(L, lua_Data); // arg
  luaL_checktype(L, -1, LUA_TSTRING);

  // call lua function with 1 arg*
  result = lua_pcall(L, ONEARG, LUA_MULTRET, 0);
  if (result != LUA_OK) {
    fail("failed to run Query function", lua_tostring(L, -1), LUA_FAILURE);
  }

  // lua_response should have our answer
  char* response = calloc(*Length, sizeof(char));
  if (response == NULL) {
    fail("calloc failed allocation", NULL, C_FAILURE);
  }

  // created within lua
  C_get_string(L, lua_response, response, *Length);


  /* ======== CLEANUP LUA ====== */

  // clean up lua vars and close vm
  // (assign var = nil)
  lua_pushnil(L); lua_setglobal(L, lua_response);
  lua_pushnil(L); lua_setglobal(L, lua_Data);
  lua_pushnil(L); lua_setglobal(L, lua_Query);
  lua_pushnil(L); lua_setglobal(L, lua_qdb);
  lua_close(L);   // lua is done


  /* ======= REPORT ====== */

  size_t rlen = strlen(response);

  if (rlen > 0) {
    strncpy(Data, response, *Length-1);
    Data[rlen] = '\0';
    free(response);  // because dynamically allocated
  } else {
    fail("lua", "no response", LUA_FAILURE);
  }


  return 1;
}


// end
