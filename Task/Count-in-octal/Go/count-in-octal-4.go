import (
    "big"
    "fmt"
)

func main() {
    defer func() {
        recover()
    }()
    one := big.NewInt(1)
    for i := big.NewInt(0); ; i.Add(i, one) {
        fmt.Printf("%o\n", i)
    }
}
