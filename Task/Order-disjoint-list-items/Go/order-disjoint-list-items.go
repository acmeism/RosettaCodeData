package main

import (
	"fmt"
	"sort"
	"strings"
)

type indexSort struct {
	val sort.Interface
	ind []int
}

func (s indexSort) Len() int           { return len(s.ind) }
func (s indexSort) Less(i, j int) bool { return s.ind[i] < s.ind[j] }
func (s indexSort) Swap(i, j int) {
	s.val.Swap(s.ind[i], s.ind[j])
	s.ind[i], s.ind[j] = s.ind[j], s.ind[i]
}

func disjointSliceSort(m, n []string) []string {
	s := indexSort{sort.StringSlice(m), make([]int, 0, len(n))}
	used := make(map[int]bool)
	for _, nw := range n {
		for i, mw := range m {
			if used[i] || mw != nw {
				continue
			}
			used[i] = true
			s.ind = append(s.ind, i)
			break
		}
	}
	sort.Sort(s)
	return s.val.(sort.StringSlice)
}

func disjointStringSort(m, n string) string {
	return strings.Join(
		disjointSliceSort(strings.Fields(m), strings.Fields(n)), " ")
}

func main() {
	for _, data := range []struct{ m, n string }{
		{"the cat sat on the mat", "mat cat"},
		{"the cat sat on the mat", "cat mat"},
		{"A B C A B C A B C", "C A C A"},
		{"A B C A B D A B E", "E A D A"},
		{"A B", "B"},
		{"A B", "B A"},
		{"A B B A", "B A"},
	} {
		mp := disjointStringSort(data.m, data.n)
		fmt.Printf("%s → %s » %s\n", data.m, data.n, mp)
	}

}
