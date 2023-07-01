import posix

let MAP_ANONYMOUS {.importc: "MAP_ANONYMOUS", header: "<sys/mman.h>".}: cint

proc test(a, b: cint): cint =
  # mov EAX, [ESP+4]
  # add EAX, [ESP+8]
  # ret
  var code = [0x8B'u8, 0x44, 0x24, 0x4, 0x3, 0x44, 0x24, 0x8, 0xC3]

  # create an executable buffer
  var buf = mmap(nil, sizeof(code), PROT_READ or PROT_WRITE or PROT_EXEC,
    MAP_PRIVATE or MAP_ANONYMOUS, -1, 0)

  # copy code to the buffer
  copyMem(buf, addr code[0], sizeof(code))
  # run code
  result = cast[proc(a, b: cint): cint {.nimcall.}](buf)(a, b)
  # free buffer
  discard munmap(buf, sizeof(code))

echo test(7, 12)
