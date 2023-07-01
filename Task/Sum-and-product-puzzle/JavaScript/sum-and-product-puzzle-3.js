(() => {
    "use strict";

    // ------------- SUM AND PRODUCT PUZZLE --------------

    // main :: IO ()
    const main = () => {
        const
            // xs :: [Int]
            xs = enumFromTo(1)(100),

            // s1 s2, s3, s4 :: [(Int, Int)]
            s1 = xs.flatMap(
                x => xs.flatMap(y =>
                    (1 < x) && (x < y) && 100 > (x + y) ? [
                        [x, y]
                    ] : []
                )
            ),
            s2 = s1.filter(
                p => sumEq(p, s1).every(
                    q => 1 < mulEq(q, s1).length
                )
            ),
            s3 = s2.filter(
                p => 1 === intersectBy(pairEQ)(
                    mulEq(p, s1)
                )(s2).length
            );

        return s3.filter(
            p => 1 === intersectBy(pairEQ)(
                sumEq(p, s1)
            )(s3).length
        );
    };

    // ---------------- PROBLEM FUNCTIONS ----------------

    // add, mul :: (Int, Int) -> Int
    const
        add = xy => xy[0] + xy[1],
        mul = xy => xy[0] * xy[1],

        // sumEq, mulEq :: (Int, Int) ->
        // [(Int, Int)] -> [(Int, Int)]
        sumEq = (p, s) => {
            const addP = add(p);

            return s.filter(q => add(q) === addP);
        },
        mulEq = (p, s) => {
            const mulP = mul(p);

            return s.filter(q => mul(q) === mulP);
        },

        // pairEQ :: ((a, a) -> (a, a)) -> Bool
        pairEQ = a => b => (
            a[0] === b[0]
        ) && (a[1] === b[1]);


    // ---------------- GENERIC FUNCTIONS ----------------

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        n => Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);


    // intersectBy :: (a -> a -> Bool) -> [a] -> [a] -> [a]
    const intersectBy = eqFn =>
        // The intersection of the lists xs and ys
        // in terms of the equality defined by eq.
        xs => ys => xs.filter(
            x => ys.some(eqFn(x))
        );

    // MAIN ---
    return main();
})();
