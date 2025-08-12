-- Query.lua

--  basic kv dbase
function qdb_init ()
   qdb = {} -- global in lua
   qdb["who are you?"]   = "I am Lua"
   qdb["what are you?"]  = "I am a Lua virtual machine"
   qdb["when are you?"]  = "I am live"
   qdb["where are you?"] = "Here I am"
   qdb["how are you?"]   = "I am a fine"
   qdb["default"]        = "unknown query"

end

-- call from C with key => Data
function Query(k)

   local key  = string.lower(k)

   if (qdb[key] == nil) then key = "default" end

   lua_response = qdb[key]

end
