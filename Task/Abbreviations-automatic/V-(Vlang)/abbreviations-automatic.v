import os

fn distinct_strings(strs []string) []string {
    len := strs.len
    mut set := map[string]bool{}
    mut distinct := []string{cap: len}
    for str in strs {
        if str !in set {
            distinct << str
            set[str] = true
        }
    }
    return distinct
}

fn take_runes(s string, n int) string {
    mut i := 0
    for j in 0..s.len {
        if i == n {
            return s[..j]
        }
        i++
    }
    return s
}

fn main() {
    lines := os.read_lines('days_of_week.txt')?
    mut line_count := 0
    for l in lines {
        mut line := l

        line = line.trim(' ')
        line_count++
        if line == "" {
            println('')
            continue
        }
        days := line.split(' ')
        if days.len != 7 {
            println("There aren't 7 days in line $line_count")
            return
        }
        if distinct_strings(days).len != 7 { // implies some days have the same name
            println(" ∞ $line")
            continue
        }
        for abbrev_len := 1; ; abbrev_len++ {
            mut abbrevs := []string{len: days.len}
            for i := 0; i < days.len; i++ {
                abbrevs[i] = take_runes(days[i], abbrev_len)
            }
            if distinct_strings(abbrevs).len == 7 {
                println("${abbrev_len:2}  $line")
                break
            }
        }
    }
}
