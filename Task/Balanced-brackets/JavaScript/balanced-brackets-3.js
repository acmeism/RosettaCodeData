(() => {
    'use strict';

    // ---------------- BALANCED BRACKETS ----------------

    // firstUnbalancedBracket :: String -> String -> Maybe Int
    const firstUnbalancedBracket = brackets =>
        haystack => {
            const [openBracket, closeBracket] = [...brackets];
            const go = (xs, iDepth, iCharPosn) =>
                // iDepth: initial nesting depth (0 = closed)
                // iCharPosn: starting character position
                0 < xs.length ? (() => {
                    const
                        h = xs[0],
                        tail = xs.slice(1),
                        iNext = iDepth + (
                            brackets.includes(h) ? (
                                openBracket === h ? (
                                    1
                                ) : -1
                            ) : 0
                        );
                    return 0 > iNext ? (
                        Just(iCharPosn) // Unmatched closing bracket.
                    ) : 0 < tail.length ? go(
                        tail, iNext, 1 + iCharPosn
                    ) : 0 !== iNext ? (
                        Just(iCharPosn)
                    ) : Nothing();
                })() : 0 !== iDepth ? (
                    Just(iCharPosn)
                ) : Nothing();
            return go([...haystack], 0, 0);
        };


    // ---------------------- TEST -----------------------
    // main :: IO ()
    const main = () => {
        const
            intPairs = 6,
            strPad = ' '.repeat(4 + (2 * intPairs));
        console.log(
            enumFromTo(0)(intPairs)
            .map(pairCount => {
                const
                    stringLength = 2 * pairCount,
                    strSample = randomBrackets(stringLength);
                return "'" + strSample + "'" +
                    strPad.slice(2 + stringLength) + maybe('OK')(
                        iUnMatched => 'problem\n' +
                        ' '.repeat(1 + iUnMatched) + '^'
                    )(
                        firstUnbalancedBracket('[]')(strSample)
                    );
            }).join('\n')
        );
    };


    // Int -> String
    const randomBrackets = n =>
        enumFromTo(1)(n)
        .map(() => Math.random() < 0.5 ? (
            '['
        ) : ']').join('');


    // --------------------- GENERIC ---------------------

    // Just :: a -> Maybe a
    const Just = x => ({
        type: 'Maybe',
        Nothing: false,
        Just: x
    });


    // Nothing :: Maybe a
    const Nothing = () => ({
        type: 'Maybe',
        Nothing: true,
    });


    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        n => !isNaN(m) ? (
            Array.from({
                length: 1 + n - m
            }, (_, i) => m + i)
        ) : enumFromTo_(m)(n);


    // maybe :: b -> (a -> b) -> Maybe a -> b
    const maybe = v =>
        // Default value (v) if m is Nothing, or f(m.Just)
        f => m => m.Nothing ? (
            v
        ) : f(m.Just);

    // ---
    return main();
})();
