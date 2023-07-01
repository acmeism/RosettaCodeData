(n => {

    // diagonals :: n -> [[n]]
    function diagonals(n) {
        let diags = (xs, iCol, iRow) => {
            if (iCol < xs.length) {
                let xxs = splitAt(iCol, xs);

                return [xxs[0]].concat(diags(
                    xxs[1],
                    iCol + (iRow < n ? 1 : -1),
                    iRow + 1
                ));
            } else return [xs];
        }

        return diags(range(0, n * n - 1), 1, 1);
    }


    // Recursively read off n heads of diagonal lists
    // rowsFromDiagonals :: n -> [[n]] -> [[n]]
    function rowsFromDiagonals(n, lst) {
        if (lst.length) {
            let [edge, rest] = splitAt(n, lst);

            return [edge.map(x => x[0])]
                .concat(rowsFromDiagonals(n,
                    edge.filter(x => x.length > 1)
                    .map(x => x.slice(1))
                    .concat(rest)
                ));
        } else return [];
    }

    // GENERIC FUNCTIONS

    // splitAt :: Int -> [a] -> ([a],[a])
    function splitAt(n, xs) {
        return [xs.slice(0, n), xs.slice(n)];
    }

    // range :: From -> To -> Maybe Step -> [Int]
    // range :: Int -> Int -> Maybe Int -> [Int]
    function range(m, n, step) {
        let d = (step || 1) * (n >= m ? 1 : -1);

        return Array.from({
            length: Math.floor((n - m) / d) + 1
        }, (_, i) => m + (i * d));
    }

    // ZIG-ZAG MATRIX

    return rowsFromDiagonals(n,
        diagonals(n)
        .map((x, i) => (i % 2 || x.reverse()) && x)
    );

})(5);
