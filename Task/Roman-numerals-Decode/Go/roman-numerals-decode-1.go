package main

import (
    "errors"
    "fmt"
)

var m = map[rune]int{
    'I': 1,
    'V': 5,
    'X': 10,
    'L': 50,
    'C': 100,
    'D': 500,
    'M': 1000,
}

func parseRoman(s string) (r int, err error) {
    if s == "" {
        return 0, errors.New("Empty string")
    }
    is := []rune(s) // easier to convert string up front
    var c0 rune     // c0: roman character last read
    var cv0 int     // cv0: value of cv

    // the key to the algorithm is to process digits from right to left
    for i := len(is) - 1; i >= 0; i-- {
        // read roman digit
        c := is[i]
        k := c == 0x305 // unicode overbar combining character
        if k {
            if i == 0 {
                return 0, errors.New(
                    "Overbar combining character invalid at position 0")
            }
            i--
            c = is[i]
        }
        cv := m[c]
        if cv == 0 {
            if c == 0x0305 {
                return 0, errors.New(fmt.Sprintf(
                    "Overbar combining character invalid at position %d", i))
            } else {
                return 0, errors.New(fmt.Sprintf(
                    "Character unrecognized as Roman digit: %c", c))
            }
        }
        if k {
            c = -c // convention indicating overbar
            cv *= 1000
        }

        // handle cases of new, same, subtractive, changed, in that order.
        switch {
        default: // case 4: digit change
            fallthrough
        case c0 == 0: // case 1: no previous digit
            c0 = c
            cv0 = cv
        case c == c0: // case 2: same digit
        case cv*5 == cv0 || cv*10 == cv0: // case 3: subtractive
            // handle next digit as new.
            // a subtractive digit doesn't count as a previous digit.
            c0 = 0
            r -= cv  // subtract...
            continue // ...instead of adding
        }
        r += cv // add, in all cases except subtractive
    }
    return r, nil
}

func main() {
    // parse three numbers mentioned in task description
    for _, r := range []string{"MCMXC", "MMVIII", "MDCLXVI"} {
        v, err := parseRoman(r)
        if err != nil {
            fmt.Println(err)
        } else {
            fmt.Println(r, "==", v)
        }
    }
}
