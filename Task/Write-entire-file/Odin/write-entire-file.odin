package main

import "core:fmt"
import "core:os"


main :: proc() {

    dummy := "This is a string."
    write := os.write_entire_file("file",transmute([]u8)(dummy),false)

    // Returns an error
    write2 := os.write_entire_file_or_err("file2",transmute([]u8)(dummy),false)

    // If error than do something
    if (write2!=nil){
        fmt.println("err")
    }

}
