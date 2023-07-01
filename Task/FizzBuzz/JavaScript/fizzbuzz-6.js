(() => {

    // FIZZBUZZ --------------------------------------------------------------

    // fizzBuzz :: Int -> String
    const fizzBuzz = n =>
        caseOf(n, [
            [x => x % 15 === 0, "FizzBuzz"],
            [x => x % 3 === 0, "Fizz"],
            [x => x % 5 === 0, "Buzz"]
        ], n.toString());

    // GENERIC FUNCTIONS -----------------------------------------------------

    // caseOf :: a -> [(a -> Bool, b)] -> b -> b
    const caseOf = (e, pvs, otherwise) =>
        pvs.reduce((a, [p, v]) =>
            a !== otherwise ? a : (p(e) ? v : a), otherwise);

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = (m, n) =>
        Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i);

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f);

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // TEST ------------------------------------------------------------------
    return unlines(
        map(fizzBuzz, enumFromTo(1, 100))
    );
})();
