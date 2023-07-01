package main
import "fmt"

type xint uint64
type xgen func()(xint)

func primes() func()(xint) {
	pp, psq := make([]xint, 0), xint(25)

	var sieve func(xint, xint)xgen
	sieve = func(p, n xint) xgen {
		m, next := xint(0), xgen(nil)
		return func()(r xint) {
			if next == nil {
				r = n
				if r <= psq {
					n += p
					return
				}

				next = sieve(pp[0] * 2, psq) // chain in
				pp = pp[1:]
				psq = pp[0] * pp[0]

				m = next()
			}
			switch {
			case n < m: r, n = n, n + p
			case n > m: r, m = m, next()
			default:    r, n, m = n, n + p, next()
			}
			return
		}
	}

	f := sieve(6, 9)
	n, p := f(), xint(0)

	return func()(xint) {
		switch {
		case p < 2: p = 2
		case p < 3: p = 3
		default:
			for p += 2; p == n; {
				p += 2
				if p > n {
					n = f()
				}
			}
			pp = append(pp, p)
		}
		return p
	}
}

func main() {
	for i, p := 0, primes(); i < 100000; i++ {
		fmt.Println(p())
	}
}
