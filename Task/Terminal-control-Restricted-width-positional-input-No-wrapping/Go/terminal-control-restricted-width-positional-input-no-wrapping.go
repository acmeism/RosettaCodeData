package main

/*
#include <windows.h>
#include <conio.h>
*/
import "C"
import (
    "fmt"
    "os"
    "os/exec"
)

var conOut = C.GetStdHandle(C.STD_OUTPUT_HANDLE)

func setCursor(p C.COORD) {
    C.SetConsoleCursorPosition(conOut, p)
}

func cls() {
    cmd := exec.Command("cmd", "/c", "cls")
    cmd.Stdout = os.Stdout
    cmd.Run()
}

func getInput(row, col, width int) string {
    if row < 0 || row > 20 || col < 0 || width < 1 || width > 78 || col > (79 - width) {
        panic("Invalid parameter(s) to getInput. Terminating program")
    }
    coord := C.COORD{C.short(col), C.short(row)}
    setCursor(coord)
    var sb []byte
    full := false
    loop:
    for {
        ch := C._getch()                         // gets next character, no echo
        switch c := byte(ch); c {
        case 3, 13:
            break loop                           // break on Ctrl-C or enter key
        case 8:
            if len(sb) > 0 {                     // mimic backspace
    fmt.Print("\b \b")
                sb = sb[:len(sb) - 1]
            }
        case 0, 224:
            C._getch()                           // consume extra character
        default:
            if c >= 32 && c <= 126 && !full {
                C._putch(ch)                     // echo ascii character, ignore others
                sb = append(sb, c)
            }
        }
        full = len(sb) == width                  // can't exceed width
    }
    return string(sb)
}

func main() {
    cls() // clear the console
    s := getInput(2, 4, 8) // Windows console row/col numbering starts at 0
    coord := C.COORD{0, 22}
    setCursor(coord)
    fmt.Printf("You entered '%s'\n", s)
}
