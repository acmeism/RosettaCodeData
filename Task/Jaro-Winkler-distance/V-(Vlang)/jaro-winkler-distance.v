import os

fn jaro_sim(str1 string, str2 string) f64 {
    if str1.len == 0 && str2.len == 0 {
        return 1
    }
    if str1.len == 0 || str2.len == 0 {
        return 0
    }
    mut match_distance := str1.len
    if str2.len > match_distance {
        match_distance = str2.len
    }
    match_distance = match_distance/2 - 1
    mut str1_matches := []bool{len: str1.len}
    mut str2_matches := []bool{len: str2.len}
    mut matches := 0.0
    mut transpositions := 0.0
    for i in 0..str1.len {
        mut start := i - match_distance
        if start < 0 {
            start = 0
        }
        mut end := i + match_distance + 1
        if end > str2.len {
            end = str2.len
        }
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
    for i in 0.. str1.len {
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
    return (matches/f64(str1.len) +
        matches/f64(str2.len) +
        (matches-transpositions)/matches) / 3
}

fn jaro_winkler_dist(s string, t string) f64 {
    ls := s.len
    lt := t.len
    mut lmax := lt
    if ls < lt {
        lmax = ls
    }
    if lmax > 4 {
        lmax = 4
    }
    mut l := 0
    for i in 0 .. lmax {
        if s[i] == t[i] {
            l++
        }
    }
    js := jaro_sim(s, t)
    p := 0.1
    ws := js + f64(l)*p*(1-js)
    return 1 - ws
}

struct Wd {
    word string
    dist f64
}

fn main() {
    misspelt := [
        "accomodate", "definately", "goverment", "occured", "publically",
        "recieve", "seperate", "untill", "wich",
	]
    words := os.read_lines('unixdict.txt')?
    for ms in misspelt {
        mut closest := []Wd{}
        for word in words {
            if word == "" {
                continue
            }
            jwd := jaro_winkler_dist(ms, word)
            if jwd < 0.15 {
                closest << Wd{word, jwd}
            }
        }
        println("Misspelt word: $ms:")
		closest.sort(a.dist<b.dist)
        for i, c in closest {
            println("${c.dist:.4f} ${c.word}")
            if i == 5 {
                break
            }
        }
        println('')
    }
}
