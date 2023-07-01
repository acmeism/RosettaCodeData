package main

import "fmt"

func averageSquareDiff(f float64, preds []float64) (av float64) {
    for _, pred := range preds {
        av += (pred - f) * (pred - f)
    }
    av /= float64(len(preds))
    return
}

func diversityTheorem(truth float64, preds []float64) (float64, float64, float64) {
    av := 0.0
    for _, pred := range preds {
        av += pred
    }
    av /= float64(len(preds))
    avErr := averageSquareDiff(truth, preds)
    crowdErr := (truth - av) * (truth - av)
    div := averageSquareDiff(av, preds)
    return avErr, crowdErr, div
}

func main() {
    predsArray := [2][]float64{{48, 47, 51}, {48, 47, 51, 42}}
    truth := 49.0
    for _, preds := range predsArray {
        avErr, crowdErr, div := diversityTheorem(truth, preds)
        fmt.Printf("Average-error : %6.3f\n", avErr)
        fmt.Printf("Crowd-error   : %6.3f\n", crowdErr)
        fmt.Printf("Diversity     : %6.3f\n\n", div)
    }
}
