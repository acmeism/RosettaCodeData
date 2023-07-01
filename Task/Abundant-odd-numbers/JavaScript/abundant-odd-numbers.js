(() => {
    'use strict';
    const main = () => {

        // abundantTuple :: Int -> [(Int, Int)]
        const abundantTuple = n => {
            // Either a list containing the tuple of N
            // and its divisor sum (if n is abundant),
            // or otherwise an empty list.
            const x = divisorSum(n);
            return n < x ? ([
                Tuple(n)(x)
            ]) : [];
        };

        // divisorSum :: Int -> Int
        const divisorSum = n => {
            // Sum of the divisors of n.
            const
                floatRoot = Math.sqrt(n),
                intRoot = Math.floor(floatRoot),
                lows = filter(x => 0 === n % x)(
                    enumFromTo(1)(intRoot)
                );
            return sum(lows.concat(map(quot(n))(
                intRoot === floatRoot ? (
                    lows.slice(1, -1)
                ) : lows.slice(1)
            )));
        };

        // TEST ---------------------------------------
        console.log(
            'First 25 abundant odd numbers, with their divisor sums:'
        )
        console.log(unlines(map(showTuple)(
            take(25)(
                concatMapGen(abundantTuple)(
                    enumFromThen(1)(3)
                )
            )
        )));
        console.log(
            '\n\n1000th abundant odd number, with its divisor sum:'
        )
        console.log(showTuple(
            take(1)(drop(999)(
                concatMapGen(abundantTuple)(
                    enumFromThen(1)(3)
                )
            ))[0]
        ))
        console.log(
            '\n\nFirst abundant odd number above 10^9, with divisor sum:'
        )
        const billion = Math.pow(10, 9);
        console.log(showTuple(
            take(1)(
                concatMapGen(abundantTuple)(
                    enumFromThen(1 + billion)(3 + billion)
                )
            )[0]
        ))
    };


    // GENERAL REUSABLE FUNCTIONS -------------------------

    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = a => b => ({
        type: 'Tuple',
        '0': a,
        '1': b,
        length: 2
    });

    // concatMapGen :: (a -> [b]) -> Gen [a] -> Gen [b]
    const concatMapGen = f =>
        function*(xs) {
            let
                x = xs.next(),
                v = undefined;
            while (!x.done) {
                v = f(x.value);
                if (0 < v.length) {
                    yield v[0];
                }
                x = xs.next();
            }
        };

    // drop :: Int -> [a] -> [a]
    // drop :: Int -> Generator [a] -> Generator [a]
    // drop :: Int -> String -> String
    const drop = n => xs =>
        Infinity > length(xs) ? (
            xs.slice(n)
        ) : (take(n)(xs), xs);

    // dropAround :: (a -> Bool) -> [a] -> [a]
    // dropAround :: (Char -> Bool) -> String -> String
    const dropAround = p => xs => dropWhile(p)(
        dropWhileEnd(p)(xs)
    );

    // dropWhile :: (a -> Bool) -> [a] -> [a]
    // dropWhile :: (Char -> Bool) -> String -> String
    const dropWhile = p => xs => {
        const lng = xs.length;
        return 0 < lng ? xs.slice(
            until(i => i === lng || !p(xs[i]))(
                i => 1 + i
            )(0)
        ) : [];
    };

    // dropWhileEnd :: (a -> Bool) -> [a] -> [a]
    // dropWhileEnd :: (Char -> Bool) -> String -> String
    const dropWhileEnd = p => xs => {
        let i = xs.length;
        while (i-- && p(xs[i])) {}
        return xs.slice(0, i + 1);
    };

    // enumFromThen :: Int -> Int -> Gen [Int]
    const enumFromThen = x =>
        // A non-finite stream of integers,
        // starting with x and y, and continuing
        // with the same interval.
        function*(y) {
            const d = y - x;
            let v = y + d;
            yield x;
            yield y;
            while (true) {
                yield v;
                v = d + v;
            }
        };

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m => n =>
        Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);

    // filter :: (a -> Bool) -> [a] -> [a]
    const filter = f => xs => xs.filter(f);

    // Returns Infinity over objects without finite length.
    // This enables zip and zipWith to choose the shorter
    // argument when one is non-finite, like cycle, repeat etc

    // length :: [a] -> Int
    const length = xs =>
        (Array.isArray(xs) || 'string' === typeof xs) ? (
            xs.length
        ) : Infinity;

    // map :: (a -> b) -> [a] -> [b]
    const map = f => xs =>
        (Array.isArray(xs) ? (
            xs
        ) : xs.split('')).map(f);

    // quot :: Int -> Int -> Int
    const quot = n => m => Math.floor(n / m);

    // show :: a -> String
    const show = JSON.stringify;

    // showTuple :: Tuple -> String
    const showTuple = tpl =>
        '(' + enumFromTo(0)(tpl.length - 1)
        .map(x => unQuoted(show(tpl[x])))
        .join(',') + ')';

    // sum :: [Num] -> Num
    const sum = xs => xs.reduce((a, x) => a + x, 0);

    // take :: Int -> [a] -> [a]
    // take :: Int -> String -> String
    const take = n => xs =>
        'GeneratorFunction' !== xs.constructor.constructor.name ? (
            xs.slice(0, n)
        ) : [].concat.apply([], Array.from({
            length: n
        }, () => {
            const x = xs.next();
            return x.done ? [] : [x.value];
        }));

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // until :: (a -> Bool) -> (a -> a) -> a -> a
    const until = p => f => x => {
        let v = x;
        while (!p(v)) v = f(v);
        return v;
    };

    // unQuoted :: String -> String
    const unQuoted = s =>
        dropAround(x => 34 === x.codePointAt(0))(
            s
        );

    // MAIN ---
    return main();
})();
