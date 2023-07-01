import ctypes
import os
from ctypes import c_ubyte, c_int

code = bytes([0x8b, 0x44, 0x24, 0x04, 0x03, 0x44, 0x24, 0x08, 0xc3])

code_size = len(code)
# copy code into an executable buffer
if (os.name == 'posix'):
    import mmap
    executable_map = mmap.mmap(-1, code_size, mmap.MAP_PRIVATE | mmap.MAP_ANON, mmap.PROT_READ | mmap.PROT_WRITE | mmap.PROT_EXEC)
    # we must keep a reference to executable_map until the call, to avoid freeing the mapped memory
    executable_map.write(code)
    # the mmap object won't tell us the actual address of the mapping, but we can fish it out by allocating
    # some ctypes object over its buffer, then asking the address of that
    func_address = ctypes.addressof(c_ubyte.from_buffer(executable_map))
elif (os.name == 'nt'):
    # the mmap module doesn't support protection flags on Windows, so execute VirtualAlloc instead
    code_buffer = ctypes.create_string_buffer(code)
    PAGE_EXECUTE_READWRITE = 0x40  # Windows constants that would usually come from header files
    MEM_COMMIT = 0x1000
    executable_buffer_address = ctypes.windll.kernel32.VirtualAlloc(0, code_size, MEM_COMMIT, PAGE_EXECUTE_READWRITE)
    if (executable_buffer_address == 0):
        print('Warning: Failed to enable code execution, call will likely cause a protection fault.')
        func_address = ctypes.addressof(code_buffer)
    else:
        ctypes.memmove(executable_buffer_address, code_buffer, code_size)
        func_address = executable_buffer_address
else:
    # for other platforms, we just hope DEP isn't enabled
    code_buffer = ctypes.create_string_buffer(code)
    func_address = ctypes.addressof(code_buffer)

prototype = ctypes.CFUNCTYPE(c_int, c_ubyte, c_ubyte) # build a function prototype from return type and argument types
func = prototype(func_address)                        # build an actual function from the prototype by specifying the address
res = func(7,12)
print(res)
