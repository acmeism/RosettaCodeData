import math.big

const big_ten = big.integer_from_int(10)

fn divide(m big.Integer, n big.Integer) ![]string {
    if m < big.zero_int {
        return error('m must not be negative')
    }
    if n <= big.zero_int {
        return error('n must be positive')
    }
    mut quotient := '${(m/n)}.'
    mut c := (m % n) * big_ten
    mut zeros := 0
    for c > big.zero_int && c < n {
        c = c * big_ten
        quotient = quotient + "0"
        zeros ++
    }
    mut digits := ""
    mut passed := map[string]int{}//string:int
    mut i := 0
    for {
        mut cs := c.str()
        if cs in passed {
            prefix := digits[0..passed[cs]]
            mut repetend := digits[passed[cs]..digits.len]
            mut result := '$quotient${prefix}(${repetend})'
            result = result.replace("(0)", "").trim_right(".")
            index := result.index("(") or {-1}
            if index == -1 {
                return [result, "", '0']
            }
            result = result.replace("(", "").replace(")", "")
            for _ in 0..zeros {
                if repetend[repetend.len-1] == 0 {
                    result = result[0..result.len-1]
                    repetend = "0" + repetend[0..result.len-1]
                } else {
                    break
                }
            }
            return [result + "....", repetend, repetend.len.str()]
        }
        q := c / n
        r := c % n
        passed[cs] = i
        digits += q.str()
        i++
        c = r * big_ten
    }
    return ['FAIL','','']
}

fn main(){
    for test in [[0, 1], [1, 1], [1, 3], [1, 7], [83,60], [1, 17], [10, 13], [3227, 555],
    [476837158203125, 9223372036854775808], [1, 149], [1, 5261]] {
        a := big.integer_from_i64(test[0])
        b := big.integer_from_i64(test[1])
        res := divide(a,b) or {['Need positive numbers','','']}
        println('$a/$b = ${res[0]}')
        println("repetend is '${res[1]}'")
        println('period is ${res[2]}\n')
    }
}
