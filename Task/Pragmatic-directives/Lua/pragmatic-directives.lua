ffi = require("ffi")
ffi.cdef[[
  #pragma pack(1)
  typedef struct { char c; int i; } foo;
  #pragma pack(4)
  typedef struct { char c; int i; } bar;
]]
print(ffi.sizeof(ffi.new("foo")))
print(ffi.sizeof(ffi.new("bar")))
