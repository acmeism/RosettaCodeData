package main
import "fmt"

type xint int64
func R() (func() (xint)) {
	r, s := xint(0), func() (xint) (nil)
	return func() (xint) {
		switch {
		case r < 1: r = 1
		case r < 3: r = 3
		default:
			if s == nil {
				s = S()
				s()
			}
			r += s()
		}
		if r < 0 { panic("r overflow") }
		return r
	}
}

func S() (func() (xint)) {
	s, r1, r := xint(0), xint(0), func() (xint) (nil)
	return func() (xint) {
		if s < 2 {
			s = 2
		} else {
			if r == nil {
				r = R()
				r()
				r1 = r()
			}
			s++
			if s >  r1 { r1 = r() }
			if s == r1 { s++ }
		}
		if s < 0 { panic("s overflow") }
		return s
	}
}

func main() {
	r, sum := R(), xint(0)
	for i := 0; i < 10000000; i++ {
		sum += r()
	}
	fmt.Println(sum)
}
