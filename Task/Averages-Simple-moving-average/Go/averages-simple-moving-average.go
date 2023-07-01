package main

import "fmt"

func sma(period int) func(float64) float64 {
    var i int
    var sum float64
    var storage = make([]float64, 0, period)

    return func(input float64) (avrg float64) {
        if len(storage) < period {
            sum += input
            storage = append(storage, input)
        }

	sum += input - storage[i]
        storage[i], i = input, (i+1)%period
	avrg = sum / float64(len(storage))

	return
    }
}

func main() {
    sma3 := sma(3)
    sma5 := sma(5)
    fmt.Println("x       sma3   sma5")
    for _, x := range []float64{1, 2, 3, 4, 5, 5, 4, 3, 2, 1} {
        fmt.Printf("%5.3f  %5.3f  %5.3f\n", x, sma3(x), sma5(x))
    }
}
