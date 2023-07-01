package main

import (
    "fmt"
    "math"
    "math/big"
    "strconv"
    "strings"
)

type minmult struct {
    min  int
    mult float64
}

var abbrevs = map[string]minmult{
    "PAIRs": {4, 2}, "SCOres": {3, 20}, "DOZens": {3, 12},
    "GRoss": {2, 144}, "GREATGRoss": {7, 1728}, "GOOGOLs": {6, 1e100},
}

var metric = map[string]float64{
    "K": 1e3, "M": 1e6, "G": 1e9, "T": 1e12, "P": 1e15, "E": 1e18,
    "Z": 1e21, "Y": 1e24, "X": 1e27, "W": 1e30, "V": 1e33, "U": 1e36,
}

var binary = map[string]float64{
    "Ki": b(10), "Mi": b(20), "Gi": b(30), "Ti": b(40), "Pi": b(50), "Ei": b(60),
    "Zi": b(70), "Yi": b(80), "Xi": b(90), "Wi": b(100), "Vi": b(110), "Ui": b(120),
}

func b(e float64) float64 {
    return math.Pow(2, e)
}

func googol() *big.Float {
    g1 := new(big.Float).SetPrec(500)
    g1.SetInt64(10000000000)
    g := new(big.Float)
    g.Set(g1)
    for i := 2; i <= 10; i++ {
        g.Mul(g, g1)
    }
    return g
}

func fact(num string, d int) int {
    prod := 1
    n, _ := strconv.Atoi(num)
    for i := n; i > 0; i -= d {
        prod *= i
    }
    return prod
}

func parse(number string) *big.Float {
    bf := new(big.Float).SetPrec(500)
    t1 := new(big.Float).SetPrec(500)
    t2 := new(big.Float).SetPrec(500)
    // find index of last digit
    var i int
    for i = len(number) - 1; i >= 0; i-- {
        if '0' <= number[i] && number[i] <= '9' {
            break
        }
    }
    num := number[:i+1]
    num = strings.Replace(num, ",", "", -1) // get rid of any commas
    suf := strings.ToUpper(number[i+1:])
    if suf == "" {
        bf.SetString(num)
        return bf
    }
    if suf[0] == '!' {
        prod := fact(num, len(suf))
        bf.SetInt64(int64(prod))
        return bf
    }
    for k, v := range abbrevs {
        kk := strings.ToUpper(k)
        if strings.HasPrefix(kk, suf) && len(suf) >= v.min {
            t1.SetString(num)
            if k != "GOOGOLs" {
                t2.SetFloat64(v.mult)
            } else {
                t2 = googol() // for greater accuracy
            }
            bf.Mul(t1, t2)
            return bf
        }
    }
    bf.SetString(num)
    for k, v := range metric {
        for j := 0; j < len(suf); j++ {
            if k == suf[j:j+1] {
                if j < len(suf)-1 && suf[j+1] == 'I' {
                    t1.SetFloat64(binary[k+"i"])
                    bf.Mul(bf, t1)
                    j++
                } else {
                    t1.SetFloat64(v)
                    bf.Mul(bf, t1)
                }
            }
        }
    }
    return bf
}

func commatize(s string) string {
    if len(s) == 0 {
        return ""
    }
    neg := s[0] == '-'
    if neg {
        s = s[1:]
    }
    frac := ""
    if ix := strings.Index(s, "."); ix >= 0 {
        frac = s[ix:]
        s = s[:ix]
    }
    le := len(s)
    for i := le - 3; i >= 1; i -= 3 {
        s = s[0:i] + "," + s[i:]
    }
    if !neg {
        return s + frac
    }
    return "-" + s + frac
}

func process(numbers []string) {
    fmt.Print("numbers =  ")
    for _, number := range numbers {
        fmt.Printf("%s  ", number)
    }
    fmt.Print("\nresults =  ")
    for _, number := range numbers {
        res := parse(number)
        t := res.Text('g', 50)
        fmt.Printf("%s  ", commatize(t))
    }
    fmt.Println("\n")
}

func main() {
    numbers := []string{"2greatGRo", "24Gros", "288Doz", "1,728pairs", "172.8SCOre"}
    process(numbers)

    numbers = []string{"1,567", "+1.567k", "0.1567e-2m"}
    process(numbers)

    numbers = []string{"25.123kK", "25.123m", "2.5123e-00002G"}
    process(numbers)

    numbers = []string{"25.123kiKI", "25.123Mi", "2.5123e-00002Gi", "+.25123E-7Ei"}
    process(numbers)

    numbers = []string{"-.25123e-34Vikki", "2e-77gooGols"}
    process(numbers)

    numbers = []string{"9!", "9!!", "9!!!", "9!!!!", "9!!!!!", "9!!!!!!",
        "9!!!!!!!", "9!!!!!!!!", "9!!!!!!!!!"}
    process(numbers)
}
