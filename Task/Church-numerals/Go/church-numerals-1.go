package main

import "fmt"

type any = interface{}

type fn func(any) any

type church func(fn) fn

func zero(f fn) fn {
    return func(x any) any {
        return x
    }
}

func (c church) succ() church {
    return func(f fn) fn {
        return func(x any) any {
            return f(c(f)(x))
        }
    }
}

func (c church) add(d church) church {
    return func(f fn) fn {
        return func(x any) any {
            return c(f)(d(f)(x))
        }
    }
}

func (c church) mul(d church) church {
    return func(f fn) fn {
        return func(x any) any {
            return c(d(f))(x)
        }
    }
}

func (c church) pow(d church) church {
    di := d.toInt()
    prod := c
    for i := 1; i < di; i++ {
        prod = prod.mul(c)
    }
    return prod
}

func (c church) toInt() int {
    return c(incr)(0).(int)
}

func intToChurch(i int) church {
    if i == 0 {
        return zero
    } else {
        return intToChurch(i - 1).succ()
    }
}

func incr(i any) any {
    return i.(int) + 1
}

func main() {
    z := church(zero)
    three := z.succ().succ().succ()
    four := three.succ()

    fmt.Println("three        ->", three.toInt())
    fmt.Println("four         ->", four.toInt())
    fmt.Println("three + four ->", three.add(four).toInt())
    fmt.Println("three * four ->", three.mul(four).toInt())
    fmt.Println("three ^ four ->", three.pow(four).toInt())
    fmt.Println("four ^ three ->", four.pow(three).toInt())
    fmt.Println("5 -> five    ->", intToChurch(5).toInt())
}
