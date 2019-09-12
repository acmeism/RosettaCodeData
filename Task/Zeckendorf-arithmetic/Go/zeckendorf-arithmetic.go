package main

import (
    "fmt"
    "strings"
)

var (
    dig  = [3]string{"00", "01", "10"}
    dig1 = [3]string{"", "1", "10"}
)

type Zeckendorf struct{ dVal, dLen int }

func NewZeck(x string) *Zeckendorf {
    z := new(Zeckendorf)
    if x == "" {
        x = "0"
    }
    q := 1
    i := len(x) - 1
    z.dLen = i / 2
    for ; i >= 0; i-- {
        z.dVal += int(x[i]-'0') * q
        q *= 2
    }
    return z
}

func (z *Zeckendorf) a(i int) {
    for ; ; i++ {
        if z.dLen < i {
            z.dLen = i
        }
        j := (z.dVal >> uint(i*2)) & 3
        switch j {
        case 0, 1:
            return
        case 2:
            if ((z.dVal >> (uint(i+1) * 2)) & 1) != 1 {
                return
            }
            z.dVal += 1 << uint(i*2+1)
            return
        case 3:
            z.dVal &= ^(3 << uint(i*2))
            z.b((i + 1) * 2)
        }
    }
}

func (z *Zeckendorf) b(pos int) {
    if pos == 0 {
        z.Inc()
        return
    }
    if ((z.dVal >> uint(pos)) & 1) == 0 {
        z.dVal += 1 << uint(pos)
        z.a(pos / 2)
        if pos > 1 {
            z.a(pos/2 - 1)
        }
    } else {
        z.dVal &= ^(1 << uint(pos))
        z.b(pos + 1)
        temp := 1
        if pos > 1 {
            temp = 2
        }
        z.b(pos - temp)
    }
}

func (z *Zeckendorf) c(pos int) {
    if ((z.dVal >> uint(pos)) & 1) == 1 {
        z.dVal &= ^(1 << uint(pos))
        return
    }
    z.c(pos + 1)
    if pos > 0 {
        z.b(pos - 1)
    } else {
        z.Inc()
    }
}

func (z *Zeckendorf) Inc() {
    z.dVal++
    z.a(0)
}

func (z1 *Zeckendorf) PlusAssign(z2 *Zeckendorf) {
    for gn := 0; gn < (z2.dLen+1)*2; gn++ {
        if ((z2.dVal >> uint(gn)) & 1) == 1 {
            z1.b(gn)
        }
    }
}

func (z1 *Zeckendorf) MinusAssign(z2 *Zeckendorf) {
    for gn := 0; gn < (z2.dLen+1)*2; gn++ {
        if ((z2.dVal >> uint(gn)) & 1) == 1 {
            z1.c(gn)
        }
    }

    for z1.dLen > 0 && ((z1.dVal>>uint(z1.dLen*2))&3) == 0 {
        z1.dLen--
    }
}

func (z1 *Zeckendorf) TimesAssign(z2 *Zeckendorf) {
    na := z2.Copy()
    nb := z2.Copy()
    nr := new(Zeckendorf)
    for i := 0; i <= (z1.dLen+1)*2; i++ {
        if ((z1.dVal >> uint(i)) & 1) > 0 {
            nr.PlusAssign(nb)
        }
        nt := nb.Copy()
        nb.PlusAssign(na)
        na = nt.Copy()
    }
    z1.dVal = nr.dVal
    z1.dLen = nr.dLen
}

func (z *Zeckendorf) Copy() *Zeckendorf {
    return &Zeckendorf{z.dVal, z.dLen}
}

func (z1 *Zeckendorf) Compare(z2 *Zeckendorf) int {
    switch {
    case z1.dVal < z2.dVal:
        return -1
    case z1.dVal > z2.dVal:
        return 1
    default:
        return 0
    }
}

func (z *Zeckendorf) String() string {
    if z.dVal == 0 {
        return "0"
    }
    var sb strings.Builder
    sb.WriteString(dig1[(z.dVal>>uint(z.dLen*2))&3])
    for i := z.dLen - 1; i >= 0; i-- {
        sb.WriteString(dig[(z.dVal>>uint(i*2))&3])
    }
    return sb.String()
}

func main() {
    fmt.Println("Addition:")
    g := NewZeck("10")
    g.PlusAssign(NewZeck("10"))
    fmt.Println(g)
    g.PlusAssign(NewZeck("10"))
    fmt.Println(g)
    g.PlusAssign(NewZeck("1001"))
    fmt.Println(g)
    g.PlusAssign(NewZeck("1000"))
    fmt.Println(g)
    g.PlusAssign(NewZeck("10101"))
    fmt.Println(g)

    fmt.Println("\nSubtraction:")
    g = NewZeck("1000")
    g.MinusAssign(NewZeck("101"))
    fmt.Println(g)
    g = NewZeck("10101010")
    g.MinusAssign(NewZeck("1010101"))
    fmt.Println(g)

    fmt.Println("\nMultiplication:")
    g = NewZeck("1001")
    g.TimesAssign(NewZeck("101"))
    fmt.Println(g)
    g = NewZeck("101010")
    g.PlusAssign(NewZeck("101"))
    fmt.Println(g)
}
