import math
fn main() {
	for n in [i64(0), 4, 6, 11, 13, 75, 100, 337, -164,
		math.max_i64,
     ] {
		println(four_is_magic(n))
	}
}

fn four_is_magic(nn i64) string {
    mut n := nn
	mut s := say(n)
	s = s[..1].to_upper() + s[1..]
	mut t := s
	for n != 4 {
		n = i64(s.len)
		s = say(n)
		t += " is " + s + ", " + s
	}
	t += " is magic."
	return t
}

const small = ["zero", "one", "two", "three", "four", "five", "six",
	"seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen",
	"fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"]
const tens = ["", "", "twenty", "thirty", "forty",
	"fifty", "sixty", "seventy", "eighty", "ninety"]
const illions = ["", " thousand", " million", " billion",
	" trillion", " quadrillion", " quintillion"]

fn say(nn i64) string {
	mut t := ''
    mut n := nn
	if n < 0 {
		t = "negative "
		// Note, for math.MinInt64 this leaves n negative.
		n = -n
	}
	match true {
	    n < 20 {
            t += small[n]
        }
        n < 100 {
            t += tens[n/10]
            s := n % 10
            if s > 0 {
                t += "-" + small[s]
            }
        }
        n < 1000 {
            t += small[n/100] + " hundred"
            s := n % 100
            if s > 0 {
                t += " " + say(s)
            }
        }
        else {
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
	}
	return t
}
