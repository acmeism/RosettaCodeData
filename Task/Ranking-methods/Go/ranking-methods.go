package main

import (
	"fmt"
	"sort"
)

type rankable interface {
	Len() int
	RankEqual(int, int) bool
}

func StandardRank(d rankable) []float64 {
	r := make([]float64, d.Len())
	var k int
	for i := range r {
		if i == 0 || !d.RankEqual(i, i-1) {
			k = i + 1
		}
		r[i] = float64(k)
	}
	return r
}

func ModifiedRank(d rankable) []float64 {
	r := make([]float64, d.Len())
	for i := range r {
		k := i + 1
		for j := i + 1; j < len(r) && d.RankEqual(i, j); j++ {
			k = j + 1
		}
		r[i] = float64(k)
	}
	return r
}

func DenseRank(d rankable) []float64 {
	r := make([]float64, d.Len())
	var k int
	for i := range r {
		if i == 0 || !d.RankEqual(i, i-1) {
			k++
		}
		r[i] = float64(k)
	}
	return r
}

func OrdinalRank(d rankable) []float64 {
	r := make([]float64, d.Len())
	for i := range r {
		r[i] = float64(i + 1)
	}
	return r
}

func FractionalRank(d rankable) []float64 {
	r := make([]float64, d.Len())
	for i := 0; i < len(r); {
		var j int
		f := float64(i + 1)
		for j = i + 1; j < len(r) && d.RankEqual(i, j); j++ {
			f += float64(j + 1)
		}
		f /= float64(j - i)
		for ; i < j; i++ {
			r[i] = f
		}
	}
	return r
}

type scores []struct {
	score int
	name  string
}

func (s scores) Len() int                { return len(s) }
func (s scores) RankEqual(i, j int) bool { return s[i].score == s[j].score }
func (s scores) Swap(i, j int)           { s[i], s[j] = s[j], s[i] }
func (s scores) Less(i, j int) bool {
	if s[i].score != s[j].score {
		return s[i].score > s[j].score
	}
	return s[i].name < s[j].name
}

var data = scores{
	{44, "Solomon"},
	{42, "Jason"},
	{42, "Errol"},
	{41, "Garry"},
	{41, "Bernard"},
	{41, "Barry"},
	{39, "Stephen"},
}

func main() {
	show := func(name string, fn func(rankable) []float64) {
		fmt.Println(name, "Ranking:")
		r := fn(data)
		for i, d := range data {
			fmt.Printf("%4v - %2d %s\n", r[i], d.score, d.name)
		}
	}

	sort.Sort(data)
	show("Standard", StandardRank)
	show("\nModified", ModifiedRank)
	show("\nDense", DenseRank)
	show("\nOrdinal", OrdinalRank)
	show("\nFractional", FractionalRank)
}
