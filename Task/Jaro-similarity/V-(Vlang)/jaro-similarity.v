import math

fn jaro(str1 string, str2 string) f64 {
    s1_len := str1.len
    s2_len := str2.len
    if s1_len == 0 && s2_len == 0 {
        return 1
    }
    if s1_len == 0 || s2_len == 0 {
        return 0
    }
    match_distance := math.max<int>(s1_len,s2_len)/2 - 1

    mut str1_matches := []bool{len: s1_len}
    mut str2_matches := []bool{len: s2_len}
    mut matches := 0
    mut transpositions := 0.0
    for i in 0..s1_len {
        start := math.max<int>(0,i - match_distance)
        end := math.min<int>(i + match_distance, s2_len)

        for k in start..end {
            if str2_matches[k] {
                continue
            }
            if str1[i] != str2[k] {
                continue
            }
            str1_matches[i] = true
            str2_matches[k] = true
            matches++
            break
        }
    }
    if matches == 0 {
        return 0
    }
    mut k := 0
    for i in 0..s1_len {
        if !str1_matches[i] {
            continue
        }
        for !str2_matches[k] {
            k++
        }
        if str1[i] != str2[k] {
            transpositions++
        }
        k++
    }
    transpositions /= 2
    return (matches/f64(s1_len) +
        matches/f64(s2_len) +
        (matches-transpositions)/matches) / 3
}

fn main() {
    println(jaro("MARTHA", "MARHTA"))
    println(jaro("DIXON", "DICKSONX"))
    println(jaro("JELLYFISH", "SMELLYFISH"))
}
