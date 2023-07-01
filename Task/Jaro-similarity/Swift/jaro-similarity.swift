 func jaroWinklerMatch(_ s: String, _ t: String) -> Double {
    let s_len: Int = s.count
    let t_len: Int = t.count

    if s_len == 0 && t_len == 0 {
        return 1.0
    }

    if s_len == 0 || t_len == 0 {
        return 0.0
    }

    var match_distance: Int = 0

    if s_len == 1 && t_len == 1 {
        match_distance = 1
    } else {
        match_distance = ([s_len, t_len].max()!/2) - 1
    }


    var s_matches = [Bool]()
    var t_matches = [Bool]()

    for _ in 1...s_len {
        s_matches.append(false)
    }

    for _ in 1...t_len {
        t_matches.append(false)
    }

    var matches: Double = 0.0
    var transpositions: Double = 0.0

    for i in 0...s_len-1 {

        let start = [0, (i-match_distance)].max()!
        let end = [(i + match_distance), t_len-1].min()!

        if start > end {
            break
        }

        for j in start...end {

            if t_matches[j] {
                continue
            }

            if s[String.Index.init(encodedOffset: i)] != t[String.Index.init(encodedOffset: j)] {
                continue
            }
            // We must have a match
            s_matches[i] = true
            t_matches[j] = true
            matches += 1
            break
        }
    }

    if matches == 0 {
        return 0.0
    }

    var k = 0
    for i in 0...s_len-1 {
        if !s_matches[i] {
            continue
        }
        while !t_matches[k] {
            k += 1
        }
        if s[String.Index.init(encodedOffset: i)] != t[String.Index.init(encodedOffset: k)] {

            transpositions += 1
        }

        k += 1
    }

    let top = (matches / Double(s_len)) + (matches / Double(t_len)) + (matches - (transpositions / 2)) / matches
    return top/3
}

print("DWAYNE/DUANE:", jaroWinklerMatch("DWAYNE", "DUANE"))
print("MARTHA/MARHTA:", jaroWinklerMatch("MARTHA", "MARHTA"))
print("DIXON/DICKSONX:", jaroWinklerMatch("DIXON", "DICKSONX"))
print("JELLYFISH/SMELLYFISH:", jaroWinklerMatch("JELLYFISH", "SMELLYFISH"))
