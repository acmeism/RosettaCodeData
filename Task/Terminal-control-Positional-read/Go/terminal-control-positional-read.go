package main

/*
#include <windows.h>
*/
import "C"
import "fmt"

func main() {
    for i := 0; i < 80*25; i++ {
        fmt.Print("A")  // fill 80 x 25 console with 'A's
    }
    fmt.Println()
    conOut := C.GetStdHandle(C.STD_OUTPUT_HANDLE)
    info := C.CONSOLE_SCREEN_BUFFER_INFO{}
    pos := C.COORD{}
    C.GetConsoleScreenBufferInfo(conOut, &info)
    pos.X = info.srWindow.Left + 3 // column number 3 of display window
    pos.Y = info.srWindow.Top + 6  // row number 6 of display window
    var c C.wchar_t
    var le C.ulong
    ret := C.ReadConsoleOutputCharacterW(conOut, &c, 1, pos, &le)
    if ret == 0 || le <= 0 {
        fmt.Println("Something went wrong!")
        return
    }
    fmt.Printf("The character at column 3, row 6 is '%c'\n", c)
}
