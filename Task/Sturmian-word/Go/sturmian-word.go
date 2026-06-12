package main

import (
	"fmt"
	"math"
	"strings"
)

func sturmianWord(m, n int) string {
	if m > n {
		result := sturmianWord(n, m)
		result = strings.ReplaceAll(result, "0", "t")
		result = strings.ReplaceAll(result, "1", "0")
		return strings.ReplaceAll(result, "t", "1")
	}
	
	var sb strings.Builder
	k, prev := 1, 0
	
	for (k*m)%n > 0 {
		curr := (k * m) / n
		if prev == curr {
			sb.WriteString("0")
		} else {
			sb.WriteString("10")
		}
		prev = curr
		k++
	}
	
	return sb.String()
}

func fibWord(n int) string {
	sn_1, sn := "0", "01"
	
	for i := 2; i <= n; i++ {
		tmp := sn
		sn = sn + sn_1
		sn_1 = tmp
	}
	
	return sn
}

func cfck(a, b, m, n, k float64) [2]int {
	p := []int{0, 1}
	q := []int{1, 0}
	r := (math.Sqrt(a) * b + m) / n
	
	for i := 0; i < int(k); i++ {
		whole := int(math.Floor(r))
		pn := whole*p[len(p)-1] + p[len(p)-2]
		qn := whole*q[len(q)-1] + q[len(q)-2]
		p = append(p, pn)
		q = append(q, qn)
		r = 1 / (r - float64(whole))
	}
	
	return [2]int{p[len(p)-1], q[len(q)-1]}
}

func main() {
	fib := fibWord(7)
	sturmian := sturmianWord(13, 21)
	
	// Check if assertion holds
	if !strings.HasPrefix(fib, sturmian) {
		panic("Assertion failed")
	}
	
	fmt.Printf(" %s <== 13/21\n", sturmian)
	
	// Calculate convergent of golden ratio
	result := cfck(5, 1, -1, 2, 8)
	goldenRatioConvergent := sturmianWord(result[0], result[1])
	fmt.Printf(" %s <== 1/phi (8th convergent golden ratio)\n", goldenRatioConvergent)
}
