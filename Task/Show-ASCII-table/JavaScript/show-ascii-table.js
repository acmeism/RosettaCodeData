(() => {

    "use strict";

    // ------------------- ASCII TABLE -------------------

    // asciiTable :: String
    const asciiTable = () =>
        transpose(
            chunksOf(16)(
                enumFromTo(32)(127)
                .map(asciiEntry)
            )
        )
        .map(
            xs => xs.map(justifyLeft(12)(" "))
            .join("")
        )
        .join("\n");

    // asciiEntry :: Int -> String
    const asciiEntry = n => {
        const k = asciiName(n);

        return "" === k ? (
            ""
        ) : `${justifyRight(4)(" ")(n.toString())} : ${k}`;
    };

    // asciiName :: Int -> String
    const asciiName = n =>
        32 > n || 127 < n ? (
            ""
        ) : 32 === n ? (
            "Spc"
        ) : 127 === n ? (
            "Del"
        ) : chr(n);

    // ---------------- GENERIC FUNCTIONS ----------------

    // chr :: Int -> Char
    const chr = x =>
        // The character at unix code-point x.
        String.fromCodePoint(x);


    // chunksOf :: Int -> [a] -> [[a]]
    const chunksOf = n => {
        // xs split into sublists of length n.
        // The last sublist will be short if n
        // does not evenly divide the length of xs .
        const go = xs => {
            const chunk = xs.slice(0, n);

            return 0 < chunk.length ? (
                [chunk].concat(
                    go(xs.slice(n))
                )
            ) : [];
        };

        return go;
    };


    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        n => Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);


    // justifyLeft :: Int -> Char -> String -> String
    const justifyLeft = n =>
        // The string s, followed by enough padding (with
        // the character c) to reach the string length n.
        c => s => n > s.length ? (
            s.padEnd(n, c)
        ) : s;


    // justifyRight :: Int -> Char -> String -> String
    const justifyRight = n =>
        // The string s, preceded by enough padding (with
        // the character c) to reach the string length n.
        c => s => Boolean(s) ? (
            s.padStart(n, c)
        ) : "";


    // transpose :: [[a]] -> [[a]]
    const transpose = rows =>
        // The columns of the input transposed
        // into new rows.
        // This version assumes input rows of even length.
        0 < rows.length ? rows[0].map(
            (x, i) => rows.flatMap(
                v => v[i]
            )
        ) : [];


    // MAIN ---
    return asciiTable();
})();
