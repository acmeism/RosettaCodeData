package main

import "fmt"

func eval(v interface{}) int {
	switch v := v.(type) {
	case int:
		return v
	case func() int:
		return v()
	}
	panic("bad type")
	return 0
}

func A(k int, x1, x2, x3, x4, x5 interface{}) (a int) {
	var B func() int
	B = func() (b int) {
		k--
		a = A(k, B, x1, x2, x3, x4)
		b = a
		return
	}
	if k <= 0 {
		a = eval(x4) + eval(x5)
	} else {
		_ = B()
	}
	return
}

func main() {
	fmt.Println(A(10, 1, -1, -1, 1, 0))
}
