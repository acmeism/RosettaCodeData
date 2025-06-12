package main

import "core:fmt"
import "core:c"
import "base:runtime"

import "core:sys/windows"


main :: proc () {


    lptextt:="Goodbye, World!"
    lptextw:= windows.utf8_to_wstring(lptextt,  context.temp_allocator)
    lptext:= transmute([^]u16)lptextw

    lptextt2:="Title"
    lptextw2:= windows.utf8_to_wstring(lptextt2,  context.temp_allocator)
    lptext2:= transmute([^]u16)lptextw2

    lastid:u32
    lastid= windows.MB_ICONWARNING
    // change last value from 0 to lastid to show warning
    dummy:=windows.MessageBoxW(nil,lptext,lptext2,0)


}
