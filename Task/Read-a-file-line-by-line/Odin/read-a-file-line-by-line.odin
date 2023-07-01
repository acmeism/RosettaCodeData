package main

import "core:os"
import "core:fmt"
import "core:bufio"
import "core:strings"

main :: proc() {
  f, err := os.open("input.txt")
  assert(err == 0, "Could not open file")
  defer os.close(f)

  r: bufio.Reader
  buffer: [1024]byte
  bufio.reader_init_with_buf(&r, {os.stream_from_handle(f)}, buffer[:])
  defer bufio.reader_destroy(&r)

  for {
    line, err := bufio.reader_read_string(&r, '\n', context.allocator)
    if err != nil do break
    defer delete(line, context.allocator)

    line = strings.trim_right(line, "\r")
    fmt.print(line)
  }
}
