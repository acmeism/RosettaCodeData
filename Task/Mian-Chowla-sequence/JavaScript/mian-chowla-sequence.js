(() => {
    'use strict';

    // main :: IO ()
    const main = () => {
        const genMianChowla = mianChowlas();
        console.log([
            'Mian-Chowla terms 1-30:',
            take(30)(
                genMianChowla
            ),

            '\nMian-Chowla terms 91-100:',
            (
                drop(60)(genMianChowla),
                take(10)(
                    genMianChowla
                )
            )
        ].join('\n') + '\n');
    };

    // mianChowlas :: Gen [Int]
    function* mianChowlas() {
        let
            mcs = [1],
            sumSet = new Set([2]),
            x = 1;
        while (true) {
            yield x;
            [sumSet, mcs, x] = nextMC(sumSet, mcs, x);
        }
    }

    // nextMC :: Set Int -> [Int] -> Int -> (Set Int, [Int], Int)
    const nextMC = (setSums, mcs, n) => {
        // Set of sums -> Series up to n -> Next term in series
        const valid = x => {
            for (const m of mcs) {
                if (setSums.has(x + m)) return false;
            }
            return true;
        };
        const x = until(valid)(x => 1 + x)(n);
        return [
            sumList(mcs)(x)
            .reduce(
                (a, n) => (a.add(n), a),
                setSums
            ),
            mcs.concat(x),
            x
        ];
    };

    // sumList :: [Int] -> Int -> [Int]
    const sumList = xs =>
        // Series so far -> additional term -> new sums
        n => [2 * n].concat(xs.map(x => n + x));


    // ---------------- GENERIC FUNCTIONS ----------------

    // drop :: Int -> [a] -> [a]
    // drop :: Int -> Generator [a] -> Generator [a]
    // drop :: Int -> String -> String
    const drop = n =>
        xs => Infinity > length(xs) ? (
            xs.slice(n)
        ) : (take(n)(xs), xs);


    // length :: [a] -> Int
    const length = xs =>
        // Returns Infinity over objects without finite
        // length. This enables zip and zipWith to choose
        // the shorter argument when one is non-finite,
        // like cycle, repeat etc
        'GeneratorFunction' !== xs.constructor
        .constructor.name ? (
            xs.length
        ) : Infinity;


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


    // until :: (a -> Bool) -> (a -> a) -> a -> a
    const until = p =>
        f => x => {
            let v = x;
            while (!p(v)) v = f(v);
            return v;
        };

    // MAIN ---
    return main();
})();
