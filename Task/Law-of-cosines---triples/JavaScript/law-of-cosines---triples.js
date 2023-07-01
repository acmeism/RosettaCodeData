(() => {
    'use strict';

    // main :: IO ()
    const main = () => {

        const
            f90 = dct => x2 => dct[x2],
            f60 = dct => (x2, ab) => dct[x2 - ab],
            f120 = dct => (x2, ab) => dct[x2 + ab],
            f60unequal = dct => (x2, ab, a, b) =>
            (a !== b) ? (
                dct[x2 - ab]
            ) : undefined;


        // triangles :: Dict -> (Int -> Int -> Int -> Int -> Maybe Int)
        //                   -> [String]
        const triangles = (f, n) => {
            const
                xs = enumFromTo(1, n),
                fr = f(xs.reduce((a, x) => (a[x * x] = x, a), {})),
                gc = xs.reduce((a, _) => a, {}),
                setSoln = new Set();
            return (
                xs.forEach(
                    a => {
                        const a2 = a * a;
                        enumFromTo(1, 1 + a).forEach(
                            b => {
                                const
                                    suma2b2 = a2 + b * b,
                                    c = fr(suma2b2, a * b, a, b);
                                if (undefined !== c) {
                                    setSoln.add([a, b, c].sort())
                                };
                            }
                        );
                    }
                ),
                Array.from(setSoln.keys())
            );
        };

        const
            result = 'Triangles of maximum side 13:\n\n' +
            unlines(
                zipWith(
                    (s, f) => {
                        const ks = triangles(f, 13);
                        return ks.length.toString() + ' solutions for ' + s +
                            ' degrees:\n' + unlines(ks) + '\n';
                    },
                    ['120', '90', '60'],
                    [f120, f90, f60]
                )
            ) + '\nUneven triangles of maximum side 10000. Total:\n' +
            triangles(f60unequal, 10000).length

        return (
            //console.log(result),
            result
        );
    };


    // GENERIC FUNCTIONS ----------------------------

    // concatMap :: (a -> [b]) -> [a] -> [b]
    const concatMap = (f, xs) =>
        xs.reduce((a, x) => a.concat(f(x)), []);

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = (m, n) =>
        m <= n ? iterateUntil(
            x => n <= x,
            x => 1 + x,
            m
        ) : [];

    // iterateUntil :: (a -> Bool) -> (a -> a) -> a -> [a]
    const iterateUntil = (p, f, x) => {
        const vs = [x];
        let h = x;
        while (!p(h))(h = f(h), vs.push(h));
        return vs;
    };

    // Returns Infinity over objects without finite length
    // this enables zip and zipWith to choose the shorter
    // argument when one non-finite like cycle, repeat etc

    // length :: [a] -> Int
    const length = xs => xs.length || Infinity;

    // take :: Int -> [a] -> [a]
    // take :: Int -> String -> String
    const take = (n, xs) =>
        xs.constructor.constructor.name !== 'GeneratorFunction' ? (
            xs.slice(0, n)
        ) : [].concat.apply([], Array.from({
            length: n
        }, () => {
            const x = xs.next();
            return x.done ? [] : [x.value];
        }));

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // Use of `take` and `length` here allows zipping with non-finite lists
    // i.e. generators like cycle, repeat, iterate.

    // Use of `take` and `length` here allows zipping with non-finite lists
    // i.e. generators like cycle, repeat, iterate.

    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = (f, xs, ys) => {
        const
            lng = Math.min(length(xs), length(ys)),
            as = take(lng, xs),
            bs = take(lng, ys);
        return Array.from({
            length: lng
        }, (_, i) => f(as[i], bs[i], i));
    };

    // MAIN ---
    return main();
})();
