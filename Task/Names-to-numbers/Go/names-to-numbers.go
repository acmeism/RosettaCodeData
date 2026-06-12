package main

import (
    "fmt"
    "math"
    "regexp"
    "strings"
)

var names = map[string]int64{
    "one":         1,
    "two":         2,
    "three":       3,
    "four":        4,
    "five":        5,
    "six":         6,
    "seven":       7,
    "eight":       8,
    "nine":        9,
    "ten":         10,
    "eleven":      11,
    "twelve":      12,
    "thirteen":    13,
    "fourteen":    14,
    "fifteen":     15,
    "sixteen":     16,
    "seventeen":   17,
    "eighteen":    18,
    "nineteen":    19,
    "twenty":      20,
    "thirty":      30,
    "forty":       40,
    "fifty":       50,
    "sixty":       60,
    "seventy":     70,
    "eighty":      80,
    "ninety":      90,
    "hundred":     100,
    "thousand":    1000,
    "million":     1000000,
    "billion":     1000000000,
    "trillion":    1000000000000,
    "quadrillion": 1000000000000000,
    "quintillion": 1000000000000000000,
}

var seps = regexp.MustCompile(`,|-| and | `)
var zeros = regexp.MustCompile(`^(zero|nought|nil|none|nothing)$`)

func nameToNum(name string) (int64, error) {
    text := strings.ToLower(strings.TrimSpace(name))
    isNegative := strings.HasPrefix(text, "minus ")
    if isNegative {
        text = text[6:]
    }
    if strings.HasPrefix(text, "a ") {
        text = "one" + text[1:]
    }
    words := seps.Split(text, -1)
    for i := len(words) - 1; i >= 0; i-- {
        if words[i] == "" {
            if i < len(words)-1 {
                copy(words[i:], words[i+1:])
            }
            words = words[:len(words)-1]
        }
    }
    size := len(words)
    if size == 1 && zeros.MatchString(words[0]) {
        return 0, nil
    }
    var multiplier, lastNum, sum int64 = 1, 0, 0
    for i := size - 1; i >= 0; i-- {
        num, ok := names[words[i]]
        if !ok {
            return 0, fmt.Errorf("'%s' is not a valid number", words[i])
        } else {
            switch {
            case num == lastNum, num >= 1000 && lastNum >= 100:
                return 0, fmt.Errorf("'%s' is not a well formed numeric string", name)
            case num >= 1000:
                multiplier = num
                if i == 0 {
                    sum += multiplier
                }
            case num >= 100:
                multiplier *= 100
                if i == 0 {
                    sum += multiplier
                }
            case num >= 20 && lastNum >= 10 && lastNum <= 90:
                return 0, fmt.Errorf("'%s' is not a well formed numeric string", name)
            case num >= 20:
                sum += num * multiplier
            case lastNum >= 1 && lastNum <= 90:
                return 0, fmt.Errorf("'%s' is not a well formed numeric string", name)
            default:
                sum += num * multiplier
            }
        }
        lastNum = num
    }

    if isNegative && sum == -sum {
        return math.MinInt64, nil
    }
    if sum < 0 {
        return 0, fmt.Errorf("'%s' is outside the range of an int64", name)
    }
    if isNegative {
        return -sum, nil
    } else {
        return sum, nil
    }
}

func main() {
    names := [...]string{
        "none",
        "one",
        "twenty-five",
        "minus one hundred and seventeen",
        "hundred and fifty-six",
        "minus two thousand two",
        "nine thousand, seven hundred, one",
        "minus six hundred and twenty six thousand, eight hundred and fourteen",
        "four million, seven hundred thousand, three hundred and eighty-six",
        "fifty-one billion, two hundred and fifty-two million, seventeen thousand, one hundred eighty-four",
        "two hundred and one billion, twenty-one million, two thousand and one",
        "minus three hundred trillion, nine million, four hundred and one thousand and thirty-one",
        "seventeen quadrillion, one hundred thirty-seven",
        "a quintillion, eight trillion and five",
        "minus nine quintillion, two hundred and twenty-three quadrillion, three hundred and seventy-two trillion, thirty-six billion, eight hundred and fifty-four million, seven hundred and seventy-five thousand, eight hundred and eight",
    }
    for _, name := range names {
        num, err := nameToNum(name)
        if err != nil {
            fmt.Println(err)
        } else {
            fmt.Printf("%20d = %s\n", num, name)
        }
    }
}
