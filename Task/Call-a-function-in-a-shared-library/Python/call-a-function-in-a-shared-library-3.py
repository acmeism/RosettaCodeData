>>> from cffi import FFI
>>> ffi = FFI()
>>> ffi.cdef("""
...     int printf(const char *format, ...);   // copy-pasted from the man page
... """)
>>> C = ffi.dlopen(None)                     # loads the entire C namespace
>>> arg = ffi.new("char[]", b"world")         # equivalent to C code: char arg[] = "world";
>>> C.printf(b"hi there, %s.\n", arg)         # call printf
hi there, world.
17
