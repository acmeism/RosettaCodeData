fn main() {
    for n in [i64(1), 2, 3, 4, 5, 11, 65, 100, 101, 272, 23456, 8007006005004003,
     ] {
        println(say_ordinal(n))
    }
}

fn say_ordinal(n i64) string {
    mut s := say(n)
    mut i := s.last_index('-') or {s.last_index(' ') or {-1}}
    i++
    // Now s[:i] is everything upto and including the space or hyphen
    // and s[i:] is the last word; we modify s[i:] as required.
    // Since LastIndex returns -1 if there was no space/hyphen,
    // `i` will be zero and this will still be fine.
    ok := s[i..] in irregular_ordinals
    x := irregular_ordinals[s[i..]]
    if ok {
        s = s[..i] + x
    } else if s[s.len-1..s.len] == 'y' {
        s = s[..i] + s[i..s.len-1] + "ieth"
    } else {
        s = s[..i] + s[i..] + "th"
    }
    return s
}

// Below is a copy of https://rosettacode.org/wiki/Number_names#Go

const (
    small = ["zero", "one", "two", "three", "four", "five", "six",
    "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen",
    "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"]
    tens = ["", "", "twenty", "thirty", "forty",
    "fifty", "sixty", "seventy", "eighty", "ninety"]
    illions = ["", " thousand", " million", " billion",
    " trillion", " quadrillion", " quintillion"]
    irregular_ordinals = {
        "one":    "first",
        "two":    "second",
        "three":  "third",
        "five":   "fifth",
        "eight":  "eighth",
        "nine":   "ninth",
        "twelve": "twelfth",
    }
)

fn say(nn i64) string {
    mut n := nn
    mut t := ''
    if n < 0 {
        t = "negative "
        // Note, for math.MinInt64 this leaves n negative.
        n = -n
    }
    if n < 20{
        t += small[n]
    } else if n < 100{
        t += tens[n/10]
        s := n % 10
        if s > 0 {
            t += "-" + small[s]
        }
    } else if n < 1000{
        t += small[n/100] + " hundred"
        s := n % 100
        if s > 0 {
            t += " " + say(s)
        }
    } else {
        // work right-to-left
        mut sx := ""
        for i := 0; n > 0; i++ {
            p := n % 1000
            n /= 1000
            if p > 0 {
                mut ix := say(p) + illions[i]
                if sx != "" {
                    ix += " " + sx
                }
                sx = ix
            }
        }
        t += sx
    }
    return t
}
