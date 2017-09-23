(() => {
    'use strict';

    // FLOYD's TRIANGLE -------------------------------------------------------

    // floyd :: Int -> [[Int]]
    const floyd = n => snd(mapAccumL(
        (start, row) => [start + row + 1, enumFromTo(start, start + row)],
        1, enumFromTo(0, n - 1)
    ));

    // showFloyd :: [[Int]] -> String
    const showFloyd = xss => {
        const ws = map(compose([succ, length, show]), last(xss));
        return unlines(
            map(xs => concat(zipWith(
                    (w, x) => justifyRight(w, ' ', show(x)), ws, xs
                )),
                xss
            )
        );
    };

    // GENERIC FUNCTIONS ------------------------------------------------------

    // compose :: [(a -> a)] -> (a -> a)
    const compose = fs => x => fs.reduceRight((a, f) => f(a), x);

    // concat :: [[a]] -> [a] | [String] -> String
    const concat = xs => {
        if (xs.length > 0) {
            const unit = typeof xs[0] === 'string' ? '' : [];
            return unit.concat.apply(unit, xs);
        } else return [];
    };

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = (m, n) =>
        Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i);

    // justifyRight :: Int -> Char -> Text -> Text
    const justifyRight = (n, cFiller, strText) =>
        n > strText.length ? (
            (cFiller.repeat(n) + strText)
            .slice(-n)
        ) : strText;

    // last :: [a] -> a
    const last = xs => xs.length ? xs.slice(-1)[0] : undefined;

    // length :: [a] -> Int
    const length = xs => xs.length;

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f)

    // 'The mapAccumL function behaves like a combination of map and foldl;
    // it applies a function to each element of a list, passing an accumulating
    // parameter from left to right, and returning a final value of this
    // accumulator together with the new list.' (See hoogle )

    // mapAccumL :: (acc -> x -> (acc, y)) -> acc -> [x] -> (acc, [y])
    const mapAccumL = (f, acc, xs) =>
        xs.reduce((a, x) => {
            const pair = f(a[0], x);

            return [pair[0], a[1].concat([pair[1]])];
        }, [acc, []]);

    // show ::
    // (a -> String) f,  Num n =>
    // a -> maybe f -> maybe n -> String
    const show = JSON.stringify;

    // snd :: (a, b) -> b
    const snd = tpl => Array.isArray(tpl) ? tpl[1] : undefined;

    // succ :: Int -> Int
    const succ = x => x + 1

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');


    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = (f, xs, ys) => {
        const ny = ys.length;
        return (xs.length <= ny ? xs : xs.slice(0, ny))
            .map((x, i) => f(x, ys[i]));
    };

    // TEST ( n=5 and n=14 rows ) ---------------------------------------------

    return unlines(map(n => showFloyd(floyd(n)) + '\n', [5, 14]))
})();
