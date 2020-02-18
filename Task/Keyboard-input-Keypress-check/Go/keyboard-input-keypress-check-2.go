package main
// stackoverflow.com/questions/43965556/how-to-read-a-key-in-go-but-continue-application-if-no-key-pressed-within-x-seco
import (
    "bufio"
    "os"
    "log"
    "fmt"
    "time"
)

var reader = bufio.NewReader(os.Stdin)

func readKey(input chan rune) {
    char, _, err := reader.ReadRune()
    if err != nil {
        log.Fatal(err)
    }
    input <- char
}

func main() {
    input := make(chan rune, 1)
    fmt.Println("Checking keyboard input...")
    go readKey(input)
    select {
        case i := <-input:
            fmt.Printf("Input : %v\n", i)
        case <-time.After(5000 * time.Millisecond):
            fmt.Println("Time out!")
    }
}
