local ffi = require("ffi")
ffi.cdef[[
char * strndup(const char * s, size_t n);
int strlen(const char *s);
]]

local s1 = "Hello, world!"
print("Original: " .. s1)
local s_s1 = ffi.C.strlen(s1)
print("strlen: " .. s_s1)

local s2 = ffi.string(ffi.C.strndup(s1, s_s1), s_s1)
print("Copy: " .. s2)
print("strlen: " .. ffi.C.strlen(s2))
