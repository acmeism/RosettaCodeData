(() => {
    'use strict';

    // isSmith :: Int -> Bool
    const isSmith = n => {
        const pfs = primeFactors(n);
        return (1 < pfs.length || n !== pfs[0]) && (
            sumDigits(n) === pfs.reduce(
                (a, x) => a + sumDigits(x),
                0
            )
        );
    };

    // TEST -----------------------------------------------

    // main :: IO ()
    const main = () => {

        // lowSmiths :: [Int]
        const lowSmiths = enumFromTo(2)(9999)
            .filter(isSmith);

        // lowSmithCount :: Int
        const lowSmithCount = lowSmiths.length;
        return [
            "Count of Smith Numbers below 10k:",
            show(lowSmithCount),
            "\nFirst 15 Smith Numbers:",
            unwords(take(15)(lowSmiths)),
            "\nLast 12 Smith Numbers below 10000:",
            unwords(drop(lowSmithCount - 12)(lowSmiths))
        ].join('\n');
    };

    // SMITH ----------------------------------------------

    // primeFactors :: Int -> [Int]
    const primeFactors = x => {
        const go = n => {
            const fs = take(1)(
                dropWhile(x => 0 != n % x)(
                    enumFromTo(2)(
                        floor(sqrt(n))
                    )
                )
            );
            return 0 === fs.length ? [n] : fs.concat(
                go(floor(n / fs[0]))
            );
        };
        return go(x);
    };

    // sumDigits :: Int -> Int
    const sumDigits = n =>
        unfoldl(
            x => 0 === x ? (
                Nothing()
            ) : Just(quotRem(x)(10))
        )(n).reduce((a, x) => a + x, 0);


    // GENERIC --------------------------------------------

    // Nothing :: Maybe a
    const Nothing = () => ({
        type: 'Maybe',
        Nothing: true,
    });

    // Just :: a -> Maybe a
    const Just = x => ({
        type: 'Maybe',
        Nothing: false,
        Just: x
    });

    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = a => b => ({
        type: 'Tuple',
        '0': a,
        '1': b,
        length: 2
    });

    // drop :: Int -> [a] -> [a]
    // drop :: Int -> String -> String
    const drop = n => xs =>
        xs.slice(n)


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

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m => n =>
        Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);

    // floor :: Num -> Int
    const floor = Math.floor;


    // quotRem :: Int -> Int -> (Int, Int)
    const quotRem = m => n =>
        Tuple(Math.floor(m / n))(
            m % n
        );

    // show :: a -> String
    const show = x => JSON.stringify(x, null, 2);

    // sqrt :: Num -> Num
    const sqrt = n =>
        (0 <= n) ? Math.sqrt(n) : undefined;

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


    // unfoldl :: (b -> Maybe (b, a)) -> b -> [a]
    const unfoldl = f => v => {
        let
            xr = [v, v],
            xs = [];
        while (true) {
            const mb = f(xr[0]);
            if (mb.Nothing) {
                return xs
            } else {
                xr = mb.Just;
                xs = [xr[1]].concat(xs);
            }
        }
    };

    // until :: (a -> Bool) -> (a -> a) -> a -> a
    const until = p => f => x => {
        let v = x;
        while (!p(v)) v = f(v);
        return v;
    };

    // unwords :: [String] -> String
    const unwords = xs => xs.join(' ');

    return main();
})();
