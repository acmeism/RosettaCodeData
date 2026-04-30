function jaro(s, t) {
    const s_len = s.length;
    const t_len = t.length;
    if (s_len === 0 && t_len === 0) return 1;
    const match_distance = Math.max(s_len, t_len) / 2 - 1;
    const s_matches = new Array(s_len).fill(false);
    const t_matches = new Array(t_len).fill(false);
    let matches = 0;
    let transpositions = 0;

    for (let i = 0; i < s_len; i++) {
        const start = Math.max(0, i - match_distance);
        const end = Math.min(i + match_distance + 1, t_len);
        for (let j = start; j < end; j++) {
            if (t_matches[j]) continue;
            if (s[i] !== t[j]) continue;
            s_matches[i] = true;
            t_matches[j] = true;
            matches++;
            break;
        }
    }

    if (matches === 0) return 0;

    let k = 0;
    for (let i = 0; i < s_len; i++) {
        if (!s_matches[i]) continue;
        while (!t_matches[k]) k++;
        if (s[i] !== t[k]) transpositions++;
        k++;
    }

    return (
        (matches / s_len) +
        (matches / t_len) +
        ((matches - transpositions / 2) / matches)
    ) / 3;
}

// Test cases
console.log(jaro("MARTHA", "MARHTA"));        // 0.9611111111111111
console.log(jaro("DIXON", "DICKSONX"));       // 0.8133333333333333
console.log(jaro("JELLYFISH", "SMELLYFISH")); // 0.8962962962962963
