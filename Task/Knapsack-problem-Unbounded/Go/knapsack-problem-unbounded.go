package main

import "fmt"

type Item struct {
	Name           string
	Value          int
	Weight, Volume float64
}

type Result struct {
	Counts []int
	Sum    int
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}

func Knapsack(items []Item, weight, volume float64) (best Result) {
	if len(items) == 0 {
		return
	}
	n := len(items) - 1
	maxCount := min(int(weight/items[n].Weight), int(volume/items[n].Volume))
	for count := 0; count <= maxCount; count++ {
		sol := Knapsack(items[:n],
			weight-float64(count)*items[n].Weight,
			volume-float64(count)*items[n].Volume)
		sol.Sum += items[n].Value * count
		if sol.Sum > best.Sum {
			sol.Counts = append(sol.Counts, count)
			best = sol
		}
	}
	return
}

func main() {
	items := []Item{
		{"Panacea", 3000, 0.3, 0.025},
		{"Ichor", 1800, 0.2, 0.015},
		{"Gold", 2500, 2.0, 0.002},
	}
	var sumCount, sumValue int
	var sumWeight, sumVolume float64

	result := Knapsack(items, 25, 0.25)

	for i := range result.Counts {
		fmt.Printf("%-8s x%3d  -> Weight: %4.1f  Volume: %5.3f  Value: %6d\n",
			items[i].Name, result.Counts[i], items[i].Weight*float64(result.Counts[i]),
			items[i].Volume*float64(result.Counts[i]), items[i].Value*result.Counts[i])

		sumCount += result.Counts[i]
		sumValue += items[i].Value * result.Counts[i]
		sumWeight += items[i].Weight * float64(result.Counts[i])
		sumVolume += items[i].Volume * float64(result.Counts[i])
	}

	fmt.Printf("TOTAL (%3d items) Weight: %4.1f  Volume: %5.3f  Value: %6d\n",
		sumCount, sumWeight, sumVolume, sumValue)
}
