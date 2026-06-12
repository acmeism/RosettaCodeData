package main

import "fmt"

func main() {
    integers := []int{1_2_3, 0b1_0_1_0_1, 0xa_bc_d, 0o4_37, 0_43_7, 0x_beef}
    for _, integer := range integers {
        fmt.Printf("%d  ", integer)
    }
    floats := []float64{1_2_3_4.2_5, 6.0_22e4, 0x_1.5p-2}
    for _, float := range floats {
        fmt.Printf("%g  ", float)
    }
    fmt.Println()
    // none of these compile
    // floats2 := []float64{_1234.25, 1234_.25, 1234._25, 1234.25_, 12__23.25}
}
