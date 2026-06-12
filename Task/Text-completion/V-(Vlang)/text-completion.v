import os

fn levenshtein(s string, t string) int {
    mut d := [][]int{len:s.len+1, init: []int{len:t.len+1}}
    for i,_ in d {
        d[i][0] = i
    }
    for j in d[0] {
        d[0][j] = j
    }
    for j := 1; j <= t.len; j++ {
        for i := 1; i <= s.len; i++ {
            if s[i-1] == t[j-1] {
                d[i][j] = d[i-1][j-1]
            } else {
                mut min := d[i-1][j]
                if d[i][j-1] < min {
                    min = d[i][j-1]
                }
                if d[i-1][j-1] < min {
                    min = d[i-1][j-1]
                }
                d[i][j] = min + 1
            }
        }

    }
    return d[s.len][t.len]
}
fn main() {
    search := "complition"
    filename := "unixdict.txt"
    words := os.read_lines(filename) or { panic('FAILED to read file: $filename')}
    mut lev := [][]string{len:4}
    for word in words {
        s := word
        ld := levenshtein(search, s)
        if ld < 4 {
            lev[ld] << s
        }
    }
    println("Input word: $search\n")
    for i in 1..4 {
        length := f64(search.len)
        similarity := (length - f64(i)) * 100 / length
        println("Words which are ${similarity:4.1f}% similar:", )
        println(lev[i])
        println('')
    }
}}
