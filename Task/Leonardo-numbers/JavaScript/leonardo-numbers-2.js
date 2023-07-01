(() => {
    'use strict';

    // leo :: Int -> Int -> Int -> Generator [Int]
    function* leo(L0, L1, delta) {
        let [x, y] = [L0, L1];
        while (true) {
            yield x;
            [x, y] = [y, delta + x + y];
        }
    }

    // ----------------------- TEST ------------------------
    // main :: IO ()
    const main = () => {
        const
            leonardo = leo(1, 1, 1),
            fibonacci = leo(0, 1, 0);

        return unlines([
            'First 25 Leonardo numbers:',
            indentWrapped(take(25)(leonardo)),
            '',
            'First 25 Fibonacci numbers:',
            indentWrapped(take(25)(fibonacci))
        ]);
    };

    // -------------------- FORMATTING ---------------------

    // indentWrapped :: [Int] -> String
    const indentWrapped = xs =>
        unlines(
            map(x => '\t' + x.join(','))(
                chunksOf(16)(
                    map(str)(xs)
                )
            )
        );

    // ----------------- GENERIC FUNCTIONS -----------------

    // chunksOf :: Int -> [a] -> [[a]]
    const chunksOf = n =>
        xs => enumFromThenTo(0)(n)(
            xs.length - 1
        ).reduce(
            (a, i) => a.concat([xs.slice(i, (n + i))]),
            []
        );

    // enumFromThenTo :: Int -> Int -> Int -> [Int]
    const enumFromThenTo = x1 =>
        x2 => y => {
            const d = x2 - x1;
            return Array.from({
                length: Math.floor(y - x2) / d + 2
            }, (_, i) => x1 + (d * i));
        };

    // map :: (a -> b) -> [a] -> [b]
    const map = f =>
        // The list obtained by applying f
        // to each element of xs.
        // (The image of xs under f).
        xs => [...xs].map(f);

    // str :: a -> String
    const str = x =>
        x.toString();

    // take :: Int -> [a] -> [a]
    // take :: Int -> String -> String
    const take = n =>
        // The first n elements of a list,
        // string of characters, or stream.
        xs => 'GeneratorFunction' !== xs
        .constructor.constructor.name ? (
            xs.slice(0, n)
        ) : [].concat.apply([], Array.from({
            length: n
        }, () => {
            const x = xs.next();
            return x.done ? [] : [x.value];
        }));

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // MAIN ---
    return main();
})();
