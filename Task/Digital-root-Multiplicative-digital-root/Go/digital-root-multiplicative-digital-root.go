package main

import "fmt"

// Only valid for n > 0 && base >= 2
func mult(n uint64, base int) (mult uint64) {
	for mult = 1; mult > 0 && n > 0; n /= uint64(base) {
		mult *= n % uint64(base)
	}
	return
}

// Only valid for n >= 0 && base >= 2
func MultDigitalRoot(n uint64, base int) (mp, mdr int) {
	var m uint64
	for m = n; m >= uint64(base); mp++ {
		m = mult(m, base)
	}
	return mp, int(m)
}

func main() {
	const base = 10
	const size = 5

	const testFmt = "%20v %3v %3v\n"
	fmt.Printf(testFmt, "Number", "MDR", "MP")
	for _, n := range [...]uint64{
		123321, 7739, 893, 899998,
		18446743999999999999,
		// From http://mathworld.wolfram.com/MultiplicativePersistence.html
		3778888999, 277777788888899,
	} {
		mp, mdr := MultDigitalRoot(n, base)
		fmt.Printf(testFmt, n, mdr, mp)
	}
	fmt.Println()

	var list [base][]uint64
	for i := range list {
		list[i] = make([]uint64, 0, size)
	}
	for cnt, n := size*base, uint64(0); cnt > 0; n++ {
		_, mdr := MultDigitalRoot(n, base)
		if len(list[mdr]) < size {
			list[mdr] = append(list[mdr], n)
			cnt--
		}
	}
	const tableFmt = "%3v: %v\n"
	fmt.Printf(tableFmt, "MDR", "First")
	for i, l := range list {
		fmt.Printf(tableFmt, i, l)
	}
}
