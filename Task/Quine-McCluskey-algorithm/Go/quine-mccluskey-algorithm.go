package main

import (
	"fmt"
	"strings"
)

type SetType struct {
	items []string
}

func b2s(i, vars int) string {
	s := ""
	for k := 0; k < vars; k++ {
		if (i & 1) == 1 {
			s = "1" + s
		} else {
			s = "0" + s
		}
		i >>= 1
	}
	return s
}

func bitCount(s string) int {
	count := 0
	for i := 0; i < len(s); i++ {
		if s[i] == '1' {
			count++
		}
	}
	return count
}

func merge(i, j string) string {
	length := len(i)
	if len(j) < length {
		length = len(j)
	}
	difCnt := 0
	s := ""
	for k := 0; k < length; k++ {
		a, b := i[k], j[k]
		if a == 'X' || b == 'X' {
			if a != b {
				return ""
			}
			s += string(a)
		} else if a != b {
			difCnt++
			if difCnt > 1 {
				return ""
			}
			s += "X"
		} else {
			s += string(a)
		}
	}
	return s
}

func addToSet(s *SetType, item string) {
	for _, str := range s.items {
		if str == item {
			return
		}
	}
	s.items = append(s.items, item)
}

func inSet(s *SetType, item string) bool {
	for _, str := range s.items {
		if str == item {
			return true
		}
	}
	return false
}

func unionSets(dest, src *SetType) {
	for _, item := range src.items {
		addToSet(dest, item)
	}
}

func computePrimes(cubes *SetType, vars int, primes *SetType) {
	sigma := make([]*SetType, vars+1)
	for i := 0; i <= vars; i++ {
		sigma[i] = &SetType{}
	}
	sigmaCount := 0

	for j := 0; j <= vars; j++ {
		for _, cube := range cubes.items {
			if bitCount(cube) == j {
				addToSet(sigma[j], cube)
			}
		}
		if len(sigma[j].items) > 0 {
			sigmaCount = j + 1
		}
	}

	primes.items = []string{}

	for sigmaCount > 0 {
		nsigma := make([]*SetType, sigmaCount-1)
		for i := 0; i < sigmaCount-1; i++ {
			nsigma[i] = &SetType{}
		}
		redundant := &SetType{}

		for i := 0; i < sigmaCount-1; i++ {
			c1 := sigma[i]
			c2 := sigma[i+1]
			nc := &SetType{}

			for _, a := range c1.items {
				for _, b := range c2.items {
					m := merge(a, b)
					if m != "" {
						addToSet(nc, m)
						addToSet(redundant, a)
						addToSet(redundant, b)
					}
				}
			}
			nsigma[i] = nc
		}

		for i := 0; i < sigmaCount; i++ {
			for _, cube := range sigma[i].items {
				if !inSet(redundant, cube) {
					addToSet(primes, cube)
				}
			}
		}

		sigmaCount = len(nsigma)
		if sigmaCount > 0 {
			for i := 0; i < sigmaCount; i++ {
				sigma[i] = nsigma[i]
			}
		}
	}
}

func activePrimes(cubesel int, primes *SetType, result *SetType) {
	result.items = []string{}
	s := b2s(cubesel, len(primes.items))
	for i := 0; i < len(primes.items); i++ {
		if s[i] == '1' {
			addToSet(result, primes.items[i])
		}
	}
}

func isCover(prime, one string) bool {
	length := len(prime)
	if len(one) < length {
		length = len(one)
	}
	for i := 0; i < length; i++ {
		p, o := prime[i], one[i]
		if p != 'X' && p != o {
			return false
		}
	}
	return true
}

func isFullCover(allPrimes, ones *SetType) bool {
	for _, one := range ones.items {
		covered := false
		for _, prime := range allPrimes.items {
			if isCover(prime, one) {
				covered = true
				break
			}
		}
		if !covered {
			return false
		}
	}
	return true
}

func unateCover(primes, ones, result *SetType) {
	minCount := 1000
	minSel := -1
	active := &SetType{}

	total := 1 << len(primes.items)
	for cubesel := 0; cubesel < total; cubesel++ {
		activePrimes(cubesel, primes, active)
		if isFullCover(active, ones) {
			cnt := 0
			binRep := b2s(cubesel, len(primes.items))
			for i := 0; i < len(binRep); i++ {
				if binRep[i] == '1' {
					cnt++
				}
			}
			if cnt < minCount {
				minCount = cnt
				minSel = cubesel
			}
		}
	}

	if minSel != -1 {
		activePrimes(minSel, primes, result)
	} else {
		result.items = []string{}
	}
}

func qm(ones, zeros, dc []int) *SetType {
	result := &SetType{}

	if len(ones) == 0 && len(zeros) == 0 && len(dc) == 0 {
		return result
	}

	maxVal := 0
	for _, val := range ones {
		if val > maxVal {
			maxVal = val
		}
	}
	for _, val := range zeros {
		if val > maxVal {
			maxVal = val
		}
	}
	for _, val := range dc {
		if val > maxVal {
			maxVal = val
		}
	}

	numvars := 0
	if maxVal == 0 {
		numvars = 1
	} else {
		tmp := maxVal
		for tmp > 0 {
			numvars++
			tmp >>= 1
		}
	}

	onesSet := &SetType{}
	zerosSet := &SetType{}
	dcSet := &SetType{}

	for _, val := range ones {
		addToSet(onesSet, b2s(val, numvars))
	}
	for _, val := range zeros {
		addToSet(zerosSet, b2s(val, numvars))
	}
	for _, val := range dc {
		addToSet(dcSet, b2s(val, numvars))
	}

	cubes := &SetType{}
	unionSets(cubes, onesSet)
	unionSets(cubes, dcSet)

	primes := &SetType{}
	computePrimes(cubes, numvars, primes)

	unateCover(primes, onesSet, result)
	return result
}

func main() {
	ones := []int{1, 2, 5}
	zeros := []int{}
	dc := []int{0, 7}

	result := qm(ones, zeros, dc)

	output := strings.Builder{}
	for i, item := range result.items {
		if i > 0 {
			output.WriteString(" ")
		}
		output.WriteString(item)
	}
	fmt.Println(output.String())
}
