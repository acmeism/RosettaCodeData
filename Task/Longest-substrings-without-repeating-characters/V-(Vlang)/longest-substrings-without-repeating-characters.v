fn substrings(s string) []string {
    n := s.len
    if n == 0 {
        return [""]
    }
    mut ss := []string{}
    for i in 0..n {
        for le := 1; le <= n-i; le++ {
            ss << s[i..i+le]
        }
    }
    return ss
}

fn distinct_runes(chars []rune) []rune {
    mut m := map[rune]bool{}
    for c in chars {
        m[c] = true
    }
    mut l := []rune{}
    for k,_ in m {
        l << k
    }
    return l
}

fn distinct_strings(strings []string) []string {
    mut m := map[string]bool{}
    for str in strings {
        m[str] = true
    }
    mut l := []string{}
    for k,_ in m {
        l << k
    }
    return l
}

fn main() {
    println("The longest substring(s) of the following without repeating characters are:\n")
    strs := ["xyzyabcybdfd", "xyzyab", "zzzzz", "a", ""]
    for s in strs {
        mut longest := []string{}
        mut longest_len := 0
        for ss in substrings(s) {
            if distinct_runes(ss.runes()).len == ss.len {
                if ss.len >= longest_len {
                    if ss.len > longest_len {
                        longest = longest[..0]
                        longest_len = ss.len
                    }
                    longest << ss
                }
            }
        }
        longest = distinct_strings(longest)
        println("String = '$s'")
        println(longest)
        println("Length = ${longest[0].len}\n")
    }
}
