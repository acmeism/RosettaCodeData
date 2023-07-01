(() => {
    'use strict';

    // attractiveNumbers :: () -> Gen [Int]
    const attractiveNumbers = () =>
        // An infinite series of attractive numbers.
        filter(
            compose(isPrime, length, primeFactors)
        )(enumFrom(1));


    // ----------------------- TEST -----------------------
    // main :: IO ()
    const main = () =>
        showCols(10)(
            takeWhile(ge(120))(
                attractiveNumbers()
            )
        );


    // ---------------------- PRIMES ----------------------

    // isPrime :: Int -> Bool
    const isPrime = n => {
        // True if n is prime.
        if (2 === n || 3 === n) {
            return true
        }
        if (2 > n || 0 === n % 2) {
            return false
        }
        if (9 > n) {
            return true
        }
        if (0 === n % 3) {
            return false
        }
        return !enumFromThenTo(5)(11)(
            1 + Math.floor(Math.pow(n, 0.5))
        ).some(x => 0 === n % x || 0 === n % (2 + x));
    };


    // primeFactors :: Int -> [Int]
    const primeFactors = n => {
        // A list of the prime factors of n.
        const
            go = x => {
                const
                    root = Math.floor(Math.sqrt(x)),
                    m = until(
                        ([q, _]) => (root < q) || (0 === (x % q))
                    )(
                        ([_, r]) => [step(r), 1 + r]
                    )([
                        0 === x % 2 ? (
                            2
                        ) : 3,
                        1
                    ])[0];
                return m > root ? (
                    [x]
                ) : ([m].concat(go(Math.floor(x / m))));
            },
            step = x => 1 + (x << 2) - ((x >> 1) << 1);
        return go(n);
    };


    // ---------------- GENERIC FUNCTIONS -----------------

    // chunksOf :: Int -> [a] -> [[a]]
    const chunksOf = n =>
        xs => enumFromThenTo(0)(n)(
            xs.length - 1
        ).reduce(
            (a, i) => a.concat([xs.slice(i, (n + i))]),
            []
        );


    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (...fs) =>
        fs.reduce(
            (f, g) => x => f(g(x)),
            x => x
        );


    // enumFrom :: Enum a => a -> [a]
    function* enumFrom(x) {
        // A non-finite succession of enumerable
        // values, starting with the value x.
        let v = x;
        while (true) {
            yield v;
            v = 1 + v;
        }
    }


    // enumFromThenTo :: Int -> Int -> Int -> [Int]
    const enumFromThenTo = x1 =>
        x2 => y => {
            const d = x2 - x1;
            return Array.from({
                length: Math.floor(y - x2) / d + 2
            }, (_, i) => x1 + (d * i));
        };


    // filter :: (a -> Bool) -> Gen [a] -> [a]
    const filter = p => xs => {
        function* go() {
            let x = xs.next();
            while (!x.done) {
                let v = x.value;
                if (p(v)) {
                    yield v
                }
                x = xs.next();
            }
        }
        return go(xs);
    };


    // ge :: Ord a => a -> a -> Bool
    const ge = x =>
        // True if x >= y
        y => x >= y;


    // justifyRight :: Int -> Char -> String -> String
    const justifyRight = n =>
        // The string s, preceded by enough padding (with
        // the character c) to reach the string length n.
        c => s => n > s.length ? (
            s.padStart(n, c)
        ) : s;


    // last :: [a] -> a
    const last = xs =>
        // The last item of a list.
        0 < xs.length ? xs.slice(-1)[0] : undefined;


    // length :: [a] -> Int
    const length = xs =>
        // Returns Infinity over objects without finite
        // length. This enables zip and zipWith to choose
        // the shorter argument when one is non-finite,
        // like cycle, repeat etc
        (Array.isArray(xs) || 'string' === typeof xs) ? (
            xs.length
        ) : Infinity;


    // map :: (a -> b) -> [a] -> [b]
    const map = f =>
        // The list obtained by applying f
        // to each element of xs.
        // (The image of xs under f).
        xs => (
            Array.isArray(xs) ? (
                xs
            ) : xs.split('')
        ).map(f);


    // showCols :: Int -> [a] -> String
    const showCols = w => xs => {
        const
            ys = xs.map(str),
            mx = last(ys).length;
        return unlines(chunksOf(w)(ys).map(
            row => row.map(justifyRight(mx)(' ')).join(' ')
        ))
    };


    // str :: a -> String
    const str = x =>
        x.toString();


    // takeWhile :: (a -> Bool) -> Gen [a] -> [a]
    const takeWhile = p => xs => {
        const ys = [];
        let
            nxt = xs.next(),
            v = nxt.value;
        while (!nxt.done && p(v)) {
            ys.push(v);
            nxt = xs.next();
            v = nxt.value
        }
        return ys;
    };


    // unlines :: [String] -> String
    const unlines = xs =>
        // A single string formed by the intercalation
        // of a list of strings with the newline character.
        xs.join('\n');


    // until :: (a -> Bool) -> (a -> a) -> a -> a
    const until = p => f => x => {
        let v = x;
        while (!p(v)) v = f(v);
        return v;
    };

    // MAIN ---
    return main();
})();
