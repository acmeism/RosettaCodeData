jaro = (s1, s2) ->
    l1 = s1.length
    l2 = s2.length
    if l1 == 0 then return if l2 == 0 then 1.0 else 0.0
    match_distance = Math.max(l1, l2) / 2 - 1
    s1_matches = []
    s2_matches = []
    m = 0
    for i in [0...l1]
        end = Math.min(i + match_distance + 1, l2)
        for k in [Math.max(0, i - match_distance)...end]
            if !s2_matches[k] and s1[i] == s2[k]
                s1_matches[i] = true
                s2_matches[k] = true
                m++
                break
    if m == 0
        0.0
    else
        t = 0.0
        k = 0
        for i in [0...l1]
            if s1_matches[i]
                until s2_matches[k] then k++
                if s1[i] != s2[k++] then t += 0.5
        (m / l1 + m / l2 + (m - t) / m) / 3.0

console.log jaro "MARTHA", "MARHTA"
console.log jaro "DIXON", "DICKSONX"
console.log jaro "JELLYFISH", "SMELLYFISH"
