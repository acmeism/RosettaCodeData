(() => {
    "use strict";

    // -------------- MULTIPLICATION TABLE ---------------

    // multTable :: Int -> Int -> [[String]]
    const multTable = m => n => {
        const xs = enumFromTo(m)(n);

        return [
            ["x", ...xs],
            ...xs.flatMap(x => [
                [x, ...xs.flatMap(
                    y => y < x
                        ? [""]
                        : [`${x * y}`]
                )]
            ])
        ];
    };

    // ---------------------- TEST -----------------------

    // main :: () -> IO String
    const main = () =>
        wikiTable({
            class: "wikitable",
            style: [
                "text-align:center",
                "width:33em",
                "height:33em",
                "table-layout:fixed"
            ]
                .join(";")
        })(
            multTable(1)(12)
        );

    // ---------------- GENERIC FUNCTIONS ----------------

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        // Enumeration of the integers from m to n.
        n => Array.from(
            { length: 1 + n - m },
            (_, i) => m + i
        );


    // ------------------- FORMATTING --------------------

    // wikiTable :: Dict -> [[a]] -> String
    const wikiTable = opts =>
        rows => {
            const
                style = ["class", "style"].reduce(
                    (a, k) => k in opts
                        ? `${a}${k}="${opts[k]}" `
                        : a,
                    ""
                ),
                body = rows.map((row, i) => {
                    const
                        cells = row.map(
                            x => `${x}` || " "
                        )
                            .join(" || ");

                    return `${i ? "|" : "!"} ${cells}`;
                })
                    .join("\n|-\n");

            return `{| ${style}\n${body}\n|}`;
        };

    //  MAIN ---
    return main();
})();
