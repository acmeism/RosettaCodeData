package main

import "core:fmt"
import "core:os"
import "core:c/libc"

main :: proc() {

    dummy := "henlo"
    succ:= os.write_entire_file("file",transmute([]u8)(dummy),false)
}
