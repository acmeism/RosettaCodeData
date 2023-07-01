package main
import (
	"fmt"
	"os"
)

func main() {
	for i, x := range os.Args[1:] {
		fmt.Printf("the argument #%d is %s\n", i, x)
	}
}
