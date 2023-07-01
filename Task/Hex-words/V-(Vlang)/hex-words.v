import os
import strconv
import math

fn digital_root(nn i64) i64 {
    mut n := nn
    for n>9 {
        mut tot := i64(0)
        for n>0 {
            tot += n%10
            n = int(math.floor(n/10))
        }
        n = tot
    }
    return n
}

fn main() {
    hex_digits := 'abcdef'
    words := os.read_lines('unixdict.txt')?
    mut lines := [][]string{}
    //println(words)
    for word in words {
        if word.len < 4 {
            continue
        }
        if word.split('').all(hex_digits.index(it) or {-1} >= 0) {
            num := strconv.parse_int(word, 16, 32) or {-1}
            lines << [word, num.str(), digital_root(num).str()]
        }
    }
    lines.sort_with_compare(fn(mut a []string, mut b []string) int {
        if a[2].int()<b[2].int(){
            return -1
        }else if a[2].int()>b[2].int(){
            return 1
        }
        return 0
    })
    for line in lines {
        println('${line[0]:8} -> ${line[1]:9} -> ${line[2]}')
    }
    println('$lines.len hex words with 4 or more letters found')
    lines = lines.filter(fn (a []string) bool {
        mut s := map[string]bool{}
        for t in a[0].split('') {
            if t !in s {
                s[t] = true
            }
        }
        return s.len > 3
    })
    for line in lines {
        println('${line[0]:8} -> ${line[1]:9} -> ${line[2]}')
    }
    println('$lines.len hex words with 4 or more distinct letters found')
}
