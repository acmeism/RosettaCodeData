((key, strPlain) => {

    // Int -> String -> String
    let caesar = (k, s) => s.split('')
        .map(c => tr(
            inRange(['a', 'z'], c) ? 'a' :
            inRange(['A', 'Z'], c) ? 'A' : 0,
            k, c
        ))
        .join('');

    // Int -> String -> String
    let unCaesar = (k, s) => caesar(26 - (k % 26), s);

    // Char -> Int -> Char -> Char
    let tr = (base, offset, char) =>
        base ? (
            String.fromCharCode(
                ord(base) + (
                    ord(char) - ord(base) + offset
                ) % 26
            )
        ) : char;

    // [a, a] -> a -> b
    let inRange = ([min, max], v) => !(v < min || v > max);

    // Char -> Int
    let ord = c => c.charCodeAt(0);

    // range :: Int -> Int -> [Int]
    let range = (m, n) =>
        Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i);

    // TEST
    let strCipher = caesar(key, strPlain),
        strDecode = unCaesar(key, strCipher);

    return [strCipher, ' -> ', strDecode];

})(114, 'Curio, Cesare venne, e vide e vinse ? ');
