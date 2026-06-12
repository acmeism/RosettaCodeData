package main

import (
    "fmt"
    "log"
    "math"
    "math/rand"
    "time"
)

var minDelta = 1.0

func getMaxPrice(prices []float64) float64 {
    max := prices[0]
    for i := 1; i < len(prices); i++ {
        if prices[i] > max {
            max = prices[i]
        }
    }
    return max
}

func getPRangeCount(prices []float64, min, max float64) int {
    count := 0
    for _, price := range prices {
        if price >= min && price <= max {
            count++
        }
    }
    return count
}

func get5000(prices []float64, min, max float64, n int) (float64, int) {
    count := getPRangeCount(prices, min, max)
    delta := (max - min) / 2
    for count != n && delta >= minDelta/2 {
        if count > n {
            max -= delta
        } else {
            max += delta
        }
        max = math.Floor(max)
        count = getPRangeCount(prices, min, max)
        delta /= 2
    }
    return max, count
}

func getAll5000(prices []float64, min, max float64, n int) [][3]float64 {
    pmax, pcount := get5000(prices, min, max, n)
    res := [][3]float64{{min, pmax, float64(pcount)}}
    for pmax < max {
        pmin := pmax + 1
        pmax, pcount = get5000(prices, pmin, max, n)
        if pcount == 0 {
            log.Fatal("Price list from", pmin, "has too many with same price.")
        }
        res = append(res, [3]float64{pmin, pmax, float64(pcount)})
    }
    return res
}

func main() {
    rand.Seed(time.Now().UnixNano())
    numPrices := 99000 + rand.Intn(2001)
    maxPrice := 1e5
    prices := make([]float64, numPrices) // list of prices
    for i := 0; i < numPrices; i++ {
        prices[i] = float64(rand.Intn(int(maxPrice) + 1))
    }
    actualMax := getMaxPrice(prices)
    fmt.Println("Using", numPrices, "items with prices from 0 to", actualMax, "\b:")
    res := getAll5000(prices, 0, actualMax, 5000)
    fmt.Println("Split into", len(res), "bins of approx 5000 elements:")
    total := 0
    for _, r := range res {
        min := int(r[0])
        tmx := r[1]
        if tmx > actualMax {
            tmx = actualMax
        }
        max := int(tmx)
        cnt := int(r[2])
        total += cnt
        fmt.Printf("   From %6d to %6d with %4d items\n", min, max, cnt)
    }
    if total != numPrices {
        fmt.Println("Something went wrong - grand total of", total, "doesn't equal", numPrices, "\b!")
    }
}
