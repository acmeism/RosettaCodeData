package main
import "fmt"
import "math/big"

func main() {
  fmt.Println(new(big.Int).Binomial(5, 3))
}
