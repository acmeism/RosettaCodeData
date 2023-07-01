package main

import "fmt"

var n = make([][]string, 15)

func initN() {
    for i := 0; i < 15; i++ {
        n[i] = make([]string, 11)
        for j := 0; j < 11; j++ {
            n[i][j] = " "
        }
        n[i][5] = "x"
    }
}

func horiz(c1, c2, r int) {
    for c := c1; c <= c2; c++ {
        n[r][c] = "x"
    }
}

func verti(r1, r2, c int) {
    for r := r1; r <= r2; r++ {
        n[r][c] = "x"
    }
}

func diagd(c1, c2, r int) {
    for c := c1; c <= c2; c++ {
        n[r+c-c1][c] = "x"
    }
}

func diagu(c1, c2, r int) {
    for c := c1; c <= c2; c++ {
        n[r-c+c1][c] = "x"
    }
}

var draw map[int]func() // map contains recursive closures

func initDraw() {
    draw = map[int]func(){
        1: func() { horiz(6, 10, 0) },
        2: func() { horiz(6, 10, 4) },
        3: func() { diagd(6, 10, 0) },
        4: func() { diagu(6, 10, 4) },
        5: func() { draw[1](); draw[4]() },
        6: func() { verti(0, 4, 10) },
        7: func() { draw[1](); draw[6]() },
        8: func() { draw[2](); draw[6]() },
        9: func() { draw[1](); draw[8]() },

        10: func() { horiz(0, 4, 0) },
        20: func() { horiz(0, 4, 4) },
        30: func() { diagu(0, 4, 4) },
        40: func() { diagd(0, 4, 0) },
        50: func() { draw[10](); draw[40]() },
        60: func() { verti(0, 4, 0) },
        70: func() { draw[10](); draw[60]() },
        80: func() { draw[20](); draw[60]() },
        90: func() { draw[10](); draw[80]() },

        100: func() { horiz(6, 10, 14) },
        200: func() { horiz(6, 10, 10) },
        300: func() { diagu(6, 10, 14) },
        400: func() { diagd(6, 10, 10) },
        500: func() { draw[100](); draw[400]() },
        600: func() { verti(10, 14, 10) },
        700: func() { draw[100](); draw[600]() },
        800: func() { draw[200](); draw[600]() },
        900: func() { draw[100](); draw[800]() },

        1000: func() { horiz(0, 4, 14) },
        2000: func() { horiz(0, 4, 10) },
        3000: func() { diagd(0, 4, 10) },
        4000: func() { diagu(0, 4, 14) },
        5000: func() { draw[1000](); draw[4000]() },
        6000: func() { verti(10, 14, 0) },
        7000: func() { draw[1000](); draw[6000]() },
        8000: func() { draw[2000](); draw[6000]() },
        9000: func() { draw[1000](); draw[8000]() },
    }
}

func printNumeral() {
    for i := 0; i < 15; i++ {
        for j := 0; j < 11; j++ {
            fmt.Printf("%s ", n[i][j])
        }
        fmt.Println()
    }
    fmt.Println()
}

func main() {
    initDraw()
    numbers := []int{0, 1, 20, 300, 4000, 5555, 6789, 9999}
    for _, number := range numbers {
        initN()
        fmt.Printf("%d:\n", number)
        thousands := number / 1000
        number %= 1000
        hundreds := number / 100
        number %= 100
        tens := number / 10
        ones := number % 10
        if thousands > 0 {
            draw[thousands*1000]()
        }
        if hundreds > 0 {
            draw[hundreds*100]()
        }
        if tens > 0 {
            draw[tens*10]()
        }
        if ones > 0 {
            draw[ones]()
        }
        printNumeral()
    }
}
