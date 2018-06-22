(() => {

    // hailstones :: Int -> [Int]
    const hailstones = x => {
        const collatz = memoized(n =>
            even(n) ? div(n, 2) : (3 * n) + 1);
        return reverse(until(
            xs => xs[0] === 1,
            xs => cons(collatz(xs[0]), xs), [x]
        ));
    };

    // collatzLength :: Int -> Int
    const collatzLength = n =>
        until(
            xi => xi[0] === 1,
            ([x, i]) => [(x % 2 ? 3 * x + 1 : x / 2), i + 1], //
            [n, 1]
        )[1];

    // GENERIC FUNCTIONS -----------------------------------------------------

    // comparing :: (a -> b) -> (a -> a -> Ordering)
    const comparing = f =>
        (x, y) => {
            const
                a = f(x),
                b = f(y);
            return a < b ? -1 : (a > b ? 1 : 0);
        };

    // cons :: a -> [a] -> [a]
    const cons = (x, xs) => [x].concat(xs);

    // div :: Int -> Int -> Int
    const div = (x, y) => Math.floor(x / y);

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = (m, n) =>
        Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i);

    // even :: Int -> Bool
    const even = n => n % 2 === 0;

    // fst :: (a, b) -> a
    const fst = pair => pair.length === 2 ? pair[0] : undefined;

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f);

    // maximumBy :: (a -> a -> Ordering) -> [a] -> a
    const maximumBy = (f, xs) =>
        xs.length > 0 ? (
            xs.slice(1)
            .reduce((a, x) => f(x, a) > 0 ? x : a, xs[0])
        ) : undefined;

    // memoized :: (a -> b) -> (a -> b)
    const memoized = f => {
        const dctMemo = {};
        return x => {
            const v = dctMemo[x];
            return v !== undefined ? v : (dctMemo[x] = f(x));
        };
    };

    // reverse :: [a] -> [a]
    const reverse = xs =>
        xs.slice(0)
        .reverse();

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // until :: (a -> Bool) -> (a -> a) -> a -> a
    const until = (p, f, x) => {
        let v = x;
        while (!p(v)) v = f(v);
        return v;
    };

    // MAIN ------------------------------------------------------------------
    const
        // ceiling :: Int
        ceiling = 100000,

        // (maxLen, maxNum) :: (Int, Int)
        [maxLen, maxNum] =
        maximumBy(
            comparing(fst),
            map(i => [collatzLength(i), i], enumFromTo(1, ceiling))
        );
    return unlines([
        'Collatz sequence for 27: ',
        `${hailstones(27)}`,
        '',
        `The number ${maxNum} has the longest hailstone sequence`,
        `for any starting number under ${ceiling}.`,
        '',
        `The length of that sequence is ${maxLen}.`
    ]);
})();
