(() => {
    "use strict";

    // --------------- SIERPINSKI TRIANGLE ---------------

    // sierpinski :: Int -> [Bool]
    const sierpinski = intOrder =>
        // Reduce/folding from the last item (base of list)
        // which has zero left indent.

        // Each preceding row has one more indent space
        // than the row beneath it.
        pascalMod2Chars(2 ** intOrder)
        .reduceRight((a, x) => ([
            `${a[1]}${x.join(" ")}\n${a[0]}`,
            `${a[1]} `
        ]), ["", ""])[0];


    // pascalMod2Chars :: Int -> [[Char]]
    const pascalMod2Chars = nRows =>
        enumFromTo(1)(nRows - 1)
        .reduce(sofar => {
            const rows = sofar.slice(-1)[0];

            // Rule 90 also reduces to the same XOR
            // relationship between left and right neighbours.
            return ([
                ...sofar,
                zipWith(
                    l => r => l === r ? (
                        " "
                    ) : "*"
                )([" ", ...rows])([...rows, " "])
            ]);
        }, [
            ["*"]
        ]);

    // ---------------------- TEST -----------------------
    // main :: IO ()
    const main = () =>
        sierpinski(4);


    // --------------------- GENERIC ---------------------

    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = f =>
        // A list constructed by zipping with a
        // custom function, rather than with the
        // default tuple constructor.
        xs => ys => xs.map(
            (x, i) => f(x)(ys[i])
        ).slice(
            0, Math.min(xs.length, ys.length)
        );


    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        n => Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);


    // MAIN ---
    return main();
})();
