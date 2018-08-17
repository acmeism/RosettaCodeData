package main

import (
	"fmt"
	"math/big"
)

func main() {
	x := big.NewInt(2)
	x = x.Exp(big.NewInt(3), x, nil)
	x = x.Exp(big.NewInt(4), x, nil)
	x = x.Exp(big.NewInt(5), x, nil)
	str := x.String()
	fmt.Printf("5^(4^(3^2)) has %d digits: %s ... %s\n",
		len(str),
		str[:20],
		str[len(str)-20:],
	)
}
