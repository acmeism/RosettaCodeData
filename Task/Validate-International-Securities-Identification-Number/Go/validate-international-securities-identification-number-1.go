package main

import "regexp"

var r = regexp.MustCompile(`^[A-Z]{2}[A-Z0-9]{9}\d$`)

var inc = [2][10]int{
	{0, 1, 2, 3, 4, 5, 6, 7, 8, 9},
	{0, 2, 4, 6, 8, 1, 3, 5, 7, 9},
}

func ValidISIN(n string) bool {
	if !r.MatchString(n) {
		return false
	}
	var sum, p int
	for i := 10; i >= 0; i-- {
		p = 1 - p
		if d := n[i]; d < 'A' {
			sum += inc[p][d-'0']
		} else {
			d -= 'A'
			sum += inc[p][d%10]
			p = 1 - p
			sum += inc[p][d/10+1]
		}
	}
	sum += int(n[11] - '0')
	return sum%10 == 0
}
