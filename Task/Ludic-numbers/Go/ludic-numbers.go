package main

import "fmt"

// Ludic returns a slice of Ludic numbers stopping after
// either n entries or when max is exceeded.
// Either argument may be <=0 to disable that limit.
func Ludic(n int, max int) []uint32 {
	const maxInt32 = 1<<31 - 1 // i.e. math.MaxInt32
	if max > 0 && n < 0 {
		n = maxInt32
	}
	if n < 1 {
		return nil
	}
	if max < 0 {
		max = maxInt32
	}
	sieve := make([]uint32, 10760) // XXX big enough for 2005 Ludics
	sieve[0] = 1
	sieve[1] = 2
	if n > 2 {
		// We start with even numbers already removed
		for i, j := 2, uint32(3); i < len(sieve); i, j = i+1, j+2 {
			sieve[i] = j
		}
		// We leave the Ludic numbers in place,
		// k is the index of the next Ludic
		for k := 2; k < n; k++ {
			l := int(sieve[k])
			if l >= max {
				n = k
				break
			}
			i := l
			l--
			// last is the last valid index
			last := k + i - 1
			for j := k + i + 1; j < len(sieve); i, j = i+1, j+1 {
				last = k + i
				sieve[last] = sieve[j]
				if i%l == 0 {
					j++
				}
			}
			// Truncate down to only the valid entries
			if last < len(sieve)-1 {
				sieve = sieve[:last+1]
			}
		}
	}
	if n > len(sieve) {
		panic("program error") // should never happen
	}
	return sieve[:n]
}

func has(x []uint32, v uint32) bool {
	for i := 0; i < len(x) && x[i] <= v; i++ {
		if x[i] == v {
			return true
		}
	}
	return false
}

func main() {
	// Ludic() is so quick we just call it repeatedly
	fmt.Println("First 25:", Ludic(25, -1))
	fmt.Println("Numner of Ludics below 1000:", len(Ludic(-1, 1000)))
	fmt.Println("Ludic 2000 to 2005:", Ludic(2005, -1)[1999:])

	fmt.Print("Tripples below 250:")
	x := Ludic(-1, 250)
	for i, v := range x[:len(x)-2] {
		if has(x[i+1:], v+2) && has(x[i+2:], v+6) {
			fmt.Printf(", (%d %d %d)", v, v+2, v+6)
		}
	}
	fmt.Println()
}
