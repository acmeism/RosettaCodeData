import posix

when defined(macosx) or defined(bsd):
  const MAP_ANONYMOUS = 0x1000
elif defined(solaris):
  const MAP_ANONYMOUS = 0x100
else:
  var
    MAP_ANONYMOUS {.importc: "MAP_ANONYMOUS", header: "<sys/mman.h>".}: cint

proc test(a, b: cint): cint =
  # mov EAX, [ESP+4]
  # add EAX, [ESP+8]
  var code = [0x8B'u8, 0x44, 0x24, 0x4, 0x3, 0x44, 0x24, 0x8, 0xC3]

  # create executable buffer
  var buf = mmap(nil, sizeof(code), PROT_READ or PROT_WRITE or PROT_EXEC,
    MAP_PRIVATE or MAP_ANONYMOUS, -1, 0)

  # copy code to buffer
  copyMem(addr buf, addr code[0], sizeof(code))

  # run code
  {.emit: "`result` = ((int (*) (int, int))&`buf`)(`a`,`b`);".}

  # free buffer
  discard munmap(buf, sizeof(code))

echo test(7, 12)
