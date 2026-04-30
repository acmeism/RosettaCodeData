package main

import "core:fmt"
import "core:slice"
import "core:sys/windows"
import "core:unicode/utf8"

filter::proc(x:u8)->bool{
    return x!='a' && x!='e' && x!='i'
}


main::proc(){


    str:="She was a soul stripper. She took my heart!"
    // transmute to u8, enough in this case
    u8_slice:=transmute([]u8)str

    // filtered with slice.filter; needs function that returns a boolean
    filter_u8_slice:=slice.filter(u8_slice,filter)
    // transmute slice to string
    new_string:=transmute(string)filter_u8_slice
    fmt.println(" New string ", new_string)


}
