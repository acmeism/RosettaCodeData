package main

import (
    "fmt"
    "math"
    "strconv"
    "strings"
)

const (
    twoI    = 2.0i
    invTwoI = 1.0 / twoI
)

type quaterImaginary struct {
    b2i string
}

func reverse(s string) string {
    r := []rune(s)
    for i, j := 0, len(r)-1; i < len(r)/2; i, j = i+1, j-1 {
        r[i], r[j] = r[j], r[i]
    }
    return string(r)
}

func newQuaterImaginary(b2i string) quaterImaginary {
    b2i = strings.TrimSpace(b2i)
    _, err := strconv.ParseFloat(b2i, 64)
    if err != nil {
        panic("invalid Base 2i number")
    }
    return quaterImaginary{b2i}
}

func toComplex(q quaterImaginary) complex128 {
    pointPos := strings.Index(q.b2i, ".")
    var posLen int
    if pointPos != -1 {
        posLen = pointPos
    } else {
        posLen = len(q.b2i)
    }
    sum := 0.0i
    prod := complex(1.0, 0.0)
    for j := 0; j < posLen; j++ {
        k := float64(q.b2i[posLen-1-j] - '0')
        if k > 0.0 {
            sum += prod * complex(k, 0.0)
        }
        prod *= twoI
    }
    if pointPos != -1 {
        prod = invTwoI
        for j := posLen + 1; j < len(q.b2i); j++ {
            k := float64(q.b2i[j] - '0')
            if k > 0.0 {
                sum += prod * complex(k, 0.0)
            }
            prod *= invTwoI
        }
    }
    return sum
}

func (q quaterImaginary) String() string {
    return q.b2i
}

// only works properly if 'real' and 'imag' are both integral
func toQuaterImaginary(c complex128) quaterImaginary {
    if c == 0i {
        return quaterImaginary{"0"}
    }
    re := int(real(c))
    im := int(imag(c))
    fi := -1
    var sb strings.Builder
    for re != 0 {
        rem := re % -4
        re /= -4
        if rem < 0 {
            rem += 4
            re++
        }
        sb.WriteString(strconv.Itoa(rem))
        sb.WriteString("0")
    }
    if im != 0 {
        f := real(complex(0.0, imag(c)) / 2.0i)
        im = int(math.Ceil(f))
        f = -4.0 * (f - float64(im))
        index := 1
        for im != 0 {
            rem := im % -4
            im /= -4
            if rem < 0 {
                rem += 4
                im++
            }
            if index < sb.Len() {
                bs := []byte(sb.String())
                bs[index] = byte(rem + 48)
                sb.Reset()
                sb.Write(bs)
            } else {
                sb.WriteString("0")
                sb.WriteString(strconv.Itoa(rem))
            }
            index += 2
        }
        fi = int(f)
    }
    s := reverse(sb.String())
    if fi != -1 {
        s = fmt.Sprintf("%s.%d", s, fi)
    }
    s = strings.TrimLeft(s, "0")
    if s[0] == '.' {
        s = "0" + s
    }
    return newQuaterImaginary(s)
}

func main() {
    for i := 1; i <= 16; i++ {
        c1 := complex(float64(i), 0.0)
        qi := toQuaterImaginary(c1)
        c2 := toComplex(qi)
        fmt.Printf("%4.0f -> %8s -> %4.0f     ", real(c1), qi, real(c2))
        c1 = -c1
        qi = toQuaterImaginary(c1)
        c2 = toComplex(qi)
        fmt.Printf("%4.0f -> %8s -> %4.0f\n", real(c1), qi, real(c2))
    }
    fmt.Println()
    for i := 1; i <= 16; i++ {
        c1 := complex(0.0, float64(i))
        qi := toQuaterImaginary(c1)
        c2 := toComplex(qi)
        fmt.Printf("%3.0fi -> %8s -> %3.0fi     ", imag(c1), qi, imag(c2))
        c1 = -c1
        qi = toQuaterImaginary(c1)
        c2 = toComplex(qi)
        fmt.Printf("%3.0fi -> %8s -> %3.0fi\n", imag(c1), qi, imag(c2))
    }
}
