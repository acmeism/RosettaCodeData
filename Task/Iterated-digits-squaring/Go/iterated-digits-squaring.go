package main

import (
	"fmt"
)

func main() {
	var d, n, o, u, u89 int64

	for n = 1; n < 100000000; n++ {
		o = n
		for {
			u = 0
			for {
				d = o%10
				o = (o - d) / 10
				u += d*d
				if o == 0 {
					break
				}
			}
			if u == 89 || u == 1 {
				if u == 89 { u89++ }
				break
			}
			o = u
		}
	}
	fmt.Println(u89)
}
