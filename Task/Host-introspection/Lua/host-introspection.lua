ffi = require("ffi")
print("size of int (in bytes):  " .. ffi.sizeof(ffi.new("int")))
print("size of pointer (in bytes):  " .. ffi.sizeof(ffi.new("int*")))
print((ffi.abi("le") and "little" or "big") .. " endian")
