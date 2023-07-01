package main

import (
    "fmt"
    "github.com/maorshutman/lm"
    "log"
    "math"
)

const (
    K  = 7_800_000_000 // approx world population
    n0 = 27            // number of cases at day 0
)

var y = []float64{
    27, 27, 27, 44, 44, 59, 59, 59, 59, 59, 59, 59, 59, 60, 60,
    61, 61, 66, 83, 219, 239, 392, 534, 631, 897, 1350, 2023,
    2820, 4587, 6067, 7823, 9826, 11946, 14554, 17372, 20615,
    24522, 28273, 31491, 34933, 37552, 40540, 43105, 45177,
    60328, 64543, 67103, 69265, 71332, 73327, 75191, 75723,
    76719, 77804, 78812, 79339, 80132, 80995, 82101, 83365,
    85203, 87024, 89068, 90664, 93077, 95316, 98172, 102133,
    105824, 109695, 114232, 118610, 125497, 133852, 143227,
    151367, 167418, 180096, 194836, 213150, 242364, 271106,
    305117, 338133, 377918, 416845, 468049, 527767, 591704,
    656866, 715353, 777796, 851308, 928436, 1000249, 1082054,
    1174652,
}

func f(dst, p []float64) {
    for i := 0; i < len(y); i++ {
        t := float64(i)
        dst[i] = (n0*math.Exp(p[0]*t))/(1+n0*(math.Exp(p[0]*t)-1)/K) - y[i]
    }
}

func main() {
    j := lm.NumJac{Func: f}
    prob := lm.LMProblem{
        Dim:        1,
        Size:       len(y),
        Func:       f,
        Jac:        j.Jac,
        InitParams: []float64{0.5},
        Tau:        1e-6,
        Eps1:       1e-8,
        Eps2:       1e-8,
    }
    res, err := lm.LM(prob, &lm.Settings{Iterations: 100, ObjectiveTol: 1e-16})
    if err != nil {
        log.Fatal(err)
    }
    r := res.X[0]
    fmt.Printf("The logistic curve r for the world data is %.8f\n", r)
    fmt.Printf("R0 is then approximately equal to %.7f\n", math.Exp(12*r))
}
