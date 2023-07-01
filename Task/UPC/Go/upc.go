package main

import (
    "fmt"
    "regexp"
)

var bits = []string{
    "0 0 0 1 1 0 1 ",
    "0 0 1 1 0 0 1 ",
    "0 0 1 0 0 1 1 ",
    "0 1 1 1 1 0 1 ",
    "0 1 0 0 0 1 1 ",
    "0 1 1 0 0 0 1 ",
    "0 1 0 1 1 1 1 ",
    "0 1 1 1 0 1 1 ",
    "0 1 1 0 1 1 1 ",
    "0 0 0 1 0 1 1 ",
}

var (
    lhs = make(map[string]int)
    rhs = make(map[string]int)
)

var weights = []int{3, 1, 3, 1, 3, 1, 3, 1, 3, 1, 3, 1}

const (
    s = "# #"
    m = " # # "
    e = "# #"
    d = "(?:#| ){7}"
)

func init() {
    for i := 0; i <= 9; i++ {
        lt := make([]byte, 7)
        rt := make([]byte, 7)
        for j := 0; j < 14; j += 2 {
            if bits[i][j] == '1' {
                lt[j/2] = '#'
                rt[j/2] = ' '
            } else {
                lt[j/2] = ' '
                rt[j/2] = '#'
            }
        }
        lhs[string(lt)] = i
        rhs[string(rt)] = i
    }
}

func reverse(s string) string {
    b := []byte(s)
    for i, j := 0, len(b)-1; i < j; i, j = i+1, j-1 {
        b[i], b[j] = b[j], b[i]
    }
    return string(b)
}

func main() {
    barcodes := []string{
        "         # #   # ##  #  ## #   ## ### ## ### ## #### # # # ## ##  #   #  ##  ## ###  # ##  ## ### #  # #       ",
        "        # # #   ##   ## # #### #   # ## #   ## #   ## # # # ###  # ###  ##  ## ###  # #  ### ###  # # #         ",
        "         # #    # # #  ###  #   #    # #  #   #    # # # # ## #   ## #   ## #   ##   # # #### ### ## # #         ",
        "       # # ##  ## ##  ##   #  #   #  # ###  # ##  ## # # #   ## ##  #  ### ## ## #   # #### ## #   # #        ",
        "         # # ### ## #   ## ## ###  ##  # ##   #   # ## # # ### #  ## ##  #    # ### #  ## ##  #      # #          ",
        "          # #  #   # ##  ##  #   #   #  # ##  ##  #   # # # # #### #  ##  # #### #### # #  ##  # #### # #         ",
        "         # #  #  ##  ##  # #   ## ##   # ### ## ##   # # # #  #   #   #  #  ### # #    ###  # #  #   # #        ",
        "        # # #    # ##  ##   #  # ##  ##  ### #   #  # # # ### ## ## ### ## ### ### ## #  ##  ### ## # #         ",
        "         # # ### ##   ## # # #### #   ## # #### # #### # # #   #  # ###  #    # ###  # #    # ###  # # #       ",
        "        # # # #### ##   # #### # #   ## ## ### #### # # # #  ### # ###  ###  # # ###  #    # #  ### # #         ",
    }

    // Regular expression to check validity of a barcode and extract digits. However we accept any number
    // of spaces at the beginning or end i.e. we don't enforce a minimum of 9.
    expr := fmt.Sprintf(`^\s*%s(%s)(%s)(%s)(%s)(%s)(%s)%s(%s)(%s)(%s)(%s)(%s)(%s)%s\s*$`,
        s, d, d, d, d, d, d, m, d, d, d, d, d, d, e)
    rx := regexp.MustCompile(expr)
    fmt.Println("UPC-A barcodes:")
    for i, bc := range barcodes {
        for j := 0; j <= 1; j++ {
            if !rx.MatchString(bc) {
                fmt.Printf("%2d: Invalid format\n", i+1)
                break
            }
            codes := rx.FindStringSubmatch(bc)
            digits := make([]int, 12)
            var invalid, ok bool // False by default.
            for i := 1; i <= 6; i++ {
                digits[i-1], ok = lhs[codes[i]]
                if !ok {
                    invalid = true
                }
                digits[i+5], ok = rhs[codes[i+6]]
                if !ok {
                    invalid = true
                }
            }
            if invalid { // Contains at least one invalid digit.
                if j == 0 { // Try reversing.
                    bc = reverse(bc)
                    continue
                } else {
                    fmt.Printf("%2d: Invalid digit(s)\n", i+1)
                    break
                }
            }
            sum := 0
            for i, d := range digits {
                sum += weights[i] * d
            }
            if sum%10 != 0 {
                fmt.Printf("%2d: Checksum error\n", i+1)
                break
            } else {
                ud := ""
                if j == 1 {
                    ud = "(upside down)"
                }
                fmt.Printf("%2d: %v %s\n", i+1, digits, ud)
                break
            }
        }
    }
}
