package main

import (
    "fmt"
    "strconv"
)

const DMAX = 20  // maximum digits
const LIMIT = 20 // maximum number of disariums to find

func main() {
    // Pre-calculated exponential and power serials
    EXP := make([][]uint64, 1+DMAX)
    POW := make([][]uint64, 1+DMAX)

    EXP[0] = make([]uint64, 11)
    EXP[1] = make([]uint64, 11)
    POW[0] = make([]uint64, 11)
    POW[1] = make([]uint64, 11)
    for i := uint64(1); i <= 10; i++ {
        EXP[1][i] = i
    }
    for i := uint64(1); i <= 9; i++ {
        POW[1][i] = i
    }
    POW[1][10] = 9

    for i := 2; i <= DMAX; i++ {
        EXP[i] = make([]uint64, 11)
        POW[i] = make([]uint64, 11)
    }
    for i := 1; i < DMAX; i++ {
        for j := 0; j <= 9; j++ {
            EXP[i+1][j] = EXP[i][j] * 10
            POW[i+1][j] = POW[i][j] * uint64(j)
        }
        EXP[i+1][10] = EXP[i][10] * 10
        POW[i+1][10] = POW[i][10] + POW[i+1][9]
    }

    // Digits of candidate and values of known low bits
    DIGITS := make([]int, 1+DMAX) // Digits form
    Exp := make([]uint64, 1+DMAX) // Number form
    Pow := make([]uint64, 1+DMAX) // Powers form

    var exp, pow, min, max uint64
    start := 1
    final := DMAX
    count := 0
    for digit := start; digit <= final; digit++ {
        fmt.Println("# of digits:", digit)
        level := 1
        DIGITS[0] = 0
        for {
            // Check limits derived from already known low bit values
            // to find the most possible candidates
            for 0 < level && level < digit {
                // Reset path to try next if checking in level is done
                if DIGITS[level] > 9 {
                    DIGITS[level] = 0
                    level--
                    DIGITS[level]++
                    continue
                }

                // Update known low bit values
                Exp[level] = Exp[level-1] + EXP[level][DIGITS[level]]
                Pow[level] = Pow[level-1] + POW[digit+1-level][DIGITS[level]]

                // Max possible value
                pow = Pow[level] + POW[digit-level][10]

                if pow < EXP[digit][1] { // Try next since upper limit is invalidly low
                    DIGITS[level]++
                    continue
                }

                max = pow % EXP[level][10]
                pow -= max
                if max < Exp[level] {
                    pow -= EXP[level][10]
                }
                max = pow + Exp[level]

                if max < EXP[digit][1] { // Try next since upper limit is invalidly low
                    DIGITS[level]++
                    continue
                }

                // Min possible value
                exp = Exp[level] + EXP[digit][1]
                pow = Pow[level] + 1

                if exp > max || max < pow { // Try next since upper limit is invalidly low
                    DIGITS[level]++
                    continue
                }

                if pow > exp {
                    min = pow % EXP[level][10]
                    pow -= min
                    if min > Exp[level] {
                        pow += EXP[level][10]
                    }
                    min = pow + Exp[level]
                } else {
                    min = exp
                }

                // Check limits existence
                if max < min {
                    DIGITS[level]++ // Try next number since current limits invalid
                } else {
                    level++ // Go for further level checking since limits available
                }
            }

            // All checking is done, escape from the main check loop
            if level < 1 {
                break
            }

            // Finally check last bit of the most possible candidates
            // Update known low bit values
            Exp[level] = Exp[level-1] + EXP[level][DIGITS[level]]
            Pow[level] = Pow[level-1] + POW[digit+1-level][DIGITS[level]]

            // Loop to check all last bits of candidates
            for DIGITS[level] < 10 {
                // Print out new Disarium number
                if Exp[level] == Pow[level] {
                    s := ""
                    for i := DMAX; i > 0; i-- {
                        s += fmt.Sprintf("%d", DIGITS[i])
                    }
                    n, _ := strconv.ParseUint(s, 10, 64)
                    fmt.Println(n)
                    count++
                    if count == LIMIT {
                        fmt.Println("\nFound the first", LIMIT, "Disarium numbers.")
                        return
                    }
                }

                // Go to followed last bit candidate
                DIGITS[level]++
                Exp[level] += EXP[level][1]
                Pow[level]++
            }

            // Reset to try next path
            DIGITS[level] = 0
            level--
            DIGITS[level]++
        }
        fmt.Println()
    }
}
