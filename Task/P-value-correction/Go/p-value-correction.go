package main

import (
    "fmt"
    "log"
    "math"
    "os"
    "sort"
    "strconv"
    "strings"
)

type pvalues = []float64

type iv1 struct {
    index int
    value float64
}
type iv2 struct{ index, value int }

type direction int

const (
    up direction = iota
    down
)

// Test also for 'Unknown' correction type.
var ctypes = []string{
    "Benjamini-Hochberg", "Benjamini-Yekutieli", "Bonferroni", "Hochberg",
    "Holm", "Hommel", "Šidák", "Unknown",
}

func minimum(p pvalues) float64 {
    m := p[0]
    for i := 1; i < len(p); i++ {
        if p[i] < m {
            m = p[i]
        }
    }
    return m
}

func maximum(p pvalues) float64 {
    m := p[0]
    for i := 1; i < len(p); i++ {
        if p[i] > m {
            m = p[i]
        }
    }
    return m
}

func adjusted(p pvalues, ctype string) (string, error) {
    err := check(p)
    if err != nil {
        return "", err
    }
    temp := pformat(adjust(p, ctype), 5)
    return fmt.Sprintf("\n%s\n%s", ctype, temp), nil
}

func pformat(p pvalues, cols int) string {
    var lines []string
    for i := 0; i < len(p); i += cols {
        fchunk := p[i : i+cols]
        schunk := make([]string, cols)
        for j := 0; j < cols; j++ {
            schunk[j] = strconv.FormatFloat(fchunk[j], 'f', 10, 64)
        }
        lines = append(lines, fmt.Sprintf("[%2d]  %s", i, strings.Join(schunk, " ")))
    }
    return strings.Join(lines, "\n")
}

func check(p []float64) error {
    cond := len(p) > 0 && minimum(p) >= 0 && maximum(p) <= 1
    if !cond {
        return fmt.Errorf("p-values must be in range 0.0 to 1.0")
    }
    return nil
}

func ratchet(p pvalues, dir direction) {
    size := len(p)
    m := p[0]
    if dir == up {
        for i := 1; i < size; i++ {
            if p[i] > m {
                p[i] = m
            }
            m = p[i]
        }
    } else {
        for i := 1; i < size; i++ {
            if p[i] < m {
                p[i] = m
            }
            m = p[i]
        }
    }
    for i := 0; i < size; i++ {
        if p[i] > 1.0 {
            p[i] = 1.0
        }
    }
}

func schwartzian(p pvalues, mult pvalues, dir direction) pvalues {
    size := len(p)
    order := make([]int, size)
    iv1s := make([]iv1, size)
    for i := 0; i < size; i++ {
        iv1s[i] = iv1{i, p[i]}
    }
    if dir == up {
        sort.Slice(iv1s, func(i, j int) bool {
            return iv1s[i].value > iv1s[j].value
        })
    } else {
        sort.Slice(iv1s, func(i, j int) bool {
            return iv1s[i].value < iv1s[j].value
        })
    }
    for i := 0; i < size; i++ {
        order[i] = iv1s[i].index
    }
    pa := make(pvalues, size)
    for i := 0; i < size; i++ {
        pa[i] = mult[i] * p[order[i]]
    }
    ratchet(pa, dir)
    order2 := make([]int, size)
    iv2s := make([]iv2, size)
    for i := 0; i < size; i++ {
        iv2s[i] = iv2{i, order[i]}
    }
    sort.Slice(iv2s, func(i, j int) bool {
        return iv2s[i].value < iv2s[j].value
    })
    for i := 0; i < size; i++ {
        order2[i] = iv2s[i].index
    }
    pa2 := make(pvalues, size)
    for i := 0; i < size; i++ {
        pa2[i] = pa[order2[i]]
    }
    return pa2
}

func adjust(p pvalues, ctype string) pvalues {
    size := len(p)
    if size == 0 {
        return p
    }
    fsize := float64(size)
    switch ctype {
    case "Benjamini-Hochberg":
        mult := make(pvalues, size)
        for i := 0; i < size; i++ {
            mult[i] = fsize / float64(size-i)
        }
        return schwartzian(p, mult, up)
    case "Benjamini-Yekutieli":
        q := 0.0
        for i := 1; i <= size; i++ {
            q += 1.0 / float64(i)
        }
        mult := make(pvalues, size)
        for i := 0; i < size; i++ {
            mult[i] = q * fsize / (fsize - float64(i))
        }
        return schwartzian(p, mult, up)
    case "Bonferroni":
        p2 := make(pvalues, size)
        for i := 0; i < size; i++ {
            p2[i] = math.Min(p[i]*fsize, 1.0)
        }
        return p2
    case "Hochberg":
        mult := make(pvalues, size)
        for i := 0; i < size; i++ {
            mult[i] = float64(i) + 1
        }
        return schwartzian(p, mult, up)
    case "Holm":
        mult := make(pvalues, size)
        for i := 0; i < size; i++ {
            mult[i] = fsize - float64(i)
        }
        return schwartzian(p, mult, down)
    case "Hommel":
        order := make([]int, size)
        iv1s := make([]iv1, size)
        for i := 0; i < size; i++ {
            iv1s[i] = iv1{i, p[i]}
        }
        sort.Slice(iv1s, func(i, j int) bool {
            return iv1s[i].value < iv1s[j].value
        })
        for i := 0; i < size; i++ {
            order[i] = iv1s[i].index
        }
        s := make(pvalues, size)
        for i := 0; i < size; i++ {
            s[i] = p[order[i]]
        }
        m := make(pvalues, size)
        for i := 0; i < size; i++ {
            m[i] = s[i] * fsize / (float64(i) + 1)
        }
        min := minimum(m)
        q := make(pvalues, size)
        for i := 0; i < size; i++ {
            q[i] = min
        }
        pa := make(pvalues, size)
        for i := 0; i < size; i++ {
            pa[i] = min
        }
        for j := size - 1; j >= 2; j-- {
            lower := make([]int, size-j+1) // lower indices
            for i := 0; i < len(lower); i++ {
                lower[i] = i
            }
            upper := make([]int, j-1) // upper indices
            for i := 0; i < len(upper); i++ {
                upper[i] = size - j + 1 + i
            }
            qmin := float64(j) * s[upper[0]] / 2.0
            for i := 1; i < len(upper); i++ {
                temp := s[upper[i]] * float64(j) / (2.0 + float64(i))
                if temp < qmin {
                    qmin = temp
                }
            }
            for i := 0; i < len(lower); i++ {
                q[lower[i]] = math.Min(s[lower[i]]*float64(j), qmin)
            }
            for i := 0; i < len(upper); i++ {
                q[upper[i]] = q[size-j]
            }
            for i := 0; i < size; i++ {
                if pa[i] < q[i] {
                    pa[i] = q[i]
                }
            }
        }
        order2 := make([]int, size)
        iv2s := make([]iv2, size)
        for i := 0; i < size; i++ {
            iv2s[i] = iv2{i, order[i]}
        }
        sort.Slice(iv2s, func(i, j int) bool {
            return iv2s[i].value < iv2s[j].value
        })
        for i := 0; i < size; i++ {
            order2[i] = iv2s[i].index
        }
        pa2 := make(pvalues, size)
        for i := 0; i < size; i++ {
            pa2[i] = pa[order2[i]]
        }
        return pa2
    case "Šidák":
        p2 := make(pvalues, size)
        for i := 0; i < size; i++ {
            p2[i] = 1.0 - math.Pow(1.0-float64(p[i]), fsize)
        }
        return p2
    default:
        fmt.Printf("\nSorry, do not know how to do '%s' correction.\n", ctype)
        fmt.Println("Perhaps you want one of these?:")
        temp := make([]string, len(ctypes)-1)
        for i := 0; i < len(temp); i++ {
            temp[i] = fmt.Sprintf("  %s", ctypes[i])
        }
        fmt.Println(strings.Join(temp, "\n"))
        os.Exit(1)
    }
    return p
}

func main() {
    p := pvalues{
        4.533744e-01, 7.296024e-01, 9.936026e-02, 9.079658e-02, 1.801962e-01,
        8.752257e-01, 2.922222e-01, 9.115421e-01, 4.355806e-01, 5.324867e-01,
        4.926798e-01, 5.802978e-01, 3.485442e-01, 7.883130e-01, 2.729308e-01,
        8.502518e-01, 4.268138e-01, 6.442008e-01, 3.030266e-01, 5.001555e-02,
        3.194810e-01, 7.892933e-01, 9.991834e-01, 1.745691e-01, 9.037516e-01,
        1.198578e-01, 3.966083e-01, 1.403837e-02, 7.328671e-01, 6.793476e-02,
        4.040730e-03, 3.033349e-04, 1.125147e-02, 2.375072e-02, 5.818542e-04,
        3.075482e-04, 8.251272e-03, 1.356534e-03, 1.360696e-02, 3.764588e-04,
        1.801145e-05, 2.504456e-07, 3.310253e-02, 9.427839e-03, 8.791153e-04,
        2.177831e-04, 9.693054e-04, 6.610250e-05, 2.900813e-02, 5.735490e-03,
    }
    for _, ctype := range ctypes {
        s, err := adjusted(p, ctype)
        if err != nil {
            log.Fatal(err)
        }
        fmt.Println(s)
    }
}
