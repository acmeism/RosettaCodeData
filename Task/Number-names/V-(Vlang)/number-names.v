const (
    small = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"]
    tens = ["", "", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"]
    illions = ["", " thousand", " million", " billion", " trillion", " quadrillion", " quintillion"]
)

fn say(n i64) string {
    mut t := ''
    mut nn := n
    if n < 0 {
        t = "negative "
        // Note, for math.MinInt64 this leaves n negative.
        nn = -n
    }
    if nn < 20 {
        t += small[nn]
    }
    else if nn < 100 {
        t += tens[nn/10]
        s := nn % 10
        if s > 0 {
            t += "-" + small[s]
        }
    }
    else if nn < 1000 {
        t += small[nn/100] + " hundred"
        s := nn % 100
        if s > 0 {
            t += " " + say(s)
        }
    }
    else {
        // work right-to-left
        mut sx := ""
        for i := 0; nn > 0; i++ {
            p := nn % 1000
            nn /= 1000
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

fn main(){
    mut nums := []i64{}
    nums = [i64(12), i64(1048576), i64(9e18), i64(-2), i64(0)]
    for n in nums {
        println(say(n))
    }
}
