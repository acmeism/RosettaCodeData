package main

import "fmt"

type triple struct{ a, b, c int }

var squares13 = make(map[int]int, 13)
var squares10000 = make(map[int]int, 10000)

func init() {
    for i := 1; i <= 13; i++ {
        squares13[i*i] = i
    }
    for i := 1; i <= 10000; i++ {
        squares10000[i*i] = i
    }
}

func solve(angle, maxLen int, allowSame bool) []triple {
    var solutions []triple
    for a := 1; a <= maxLen; a++ {
        for b := a; b <= maxLen; b++ {
            lhs := a*a + b*b
            if angle != 90 {
                switch angle {
                case 60:
                    lhs -= a * b
                case 120:
                    lhs += a * b
                default:
                    panic("Angle must be 60, 90 or 120 degrees")
                }
            }
            switch maxLen {
            case 13:
                if c, ok := squares13[lhs]; ok {
                    if !allowSame && a == b && b == c {
                        continue
                    }
                    solutions = append(solutions, triple{a, b, c})
                }
            case 10000:
                if c, ok := squares10000[lhs]; ok {
                    if !allowSame && a == b && b == c {
                        continue
                    }
                    solutions = append(solutions, triple{a, b, c})
                }
            default:
                panic("Maximum length must be either 13 or 10000")
            }
        }
    }
    return solutions
}

func main() {
    fmt.Print("For sides in the range [1, 13] ")
    fmt.Println("where they can all be of the same length:-\n")
    angles := []int{90, 60, 120}
    var solutions []triple
    for _, angle := range angles {
        solutions = solve(angle, 13, true)
        fmt.Printf("  For an angle of %d degrees", angle)
        fmt.Println(" there are", len(solutions), "solutions, namely:")
        fmt.Printf("  %v\n", solutions)
        fmt.Println()
    }
    fmt.Print("For sides in the range [1, 10000] ")
    fmt.Println("where they cannot ALL be of the same length:-\n")
    solutions = solve(60, 10000, false)
    fmt.Print("  For an angle of 60 degrees")
    fmt.Println(" there are", len(solutions), "solutions.")
}
