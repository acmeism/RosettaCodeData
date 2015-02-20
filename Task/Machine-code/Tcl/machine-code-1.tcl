package require critcl

critcl::ccode {
    #include <sys/mman.h>
}

# Define a command using C. The C is embedded in Tcl, and will be
# built into a shared library at runtime. Note that Tcl does not
# provide a native way of doing this sort of thing; this thunk is
# mandatory.
critcl::cproc runMachineCode {Tcl_Obj* codeObj int a int b} int {
    int size, result;
    unsigned char *code = Tcl_GetByteArrayFromObj(codeObj, &size);
    void *buf;

    /* copy code to executable buffer */
    buf = mmap(0, (size_t) size, PROT_READ|PROT_WRITE|PROT_EXEC,
            MAP_PRIVATE|MAP_ANON, -1, 0);
    memcpy(buf, code, (size_t) size);
    /* run code */
    result = ((int (*) (int, int)) buf)(a, b);
    /* dispose buffer */
    munmap(buf, (size_t) size);

    return result;
}

# But now we have our thunk, we can execute arbitrary binary blobs
set code [binary format c* {0x8B 0x44 0x24 0x4 0x3 0x44 0x24 0x8 0xC3}]
puts [runMachineCode $code 7 12]
