!ExternalBytes class methods!

mapExecutableBytes:size
%{
#   include <sys/mman.h>

    void *mem;
    OBJ retVal;
    int nBytes = __intVal(size);

    mem = mmap(nil, nBytes, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_ANON, -1, 0);
    if (mem != MAP_FAILED) {
        RETURN( __MKEXTERNALBYTES_N(mem, nBytes));
    }
%}.
    self primitiveFailed
! !
