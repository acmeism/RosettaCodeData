(() => {
    'use strict';

    // -------------- NO CONNECTION PUZZLE ---------------

    // solvedPuzzle :: () -> [Int]
    const solvedPuzzle = () => {

        // universe :: [[Int]]
        const universe = permutations(enumFromTo(1)(8));

        // isSolution :: [Int] -> Bool
        const isSolution = ([a, b, c, d, e, f, g, h]) =>
            all(x => abs(x) > 1)([
                a - d, c - d, g - d, e - d, a - c, c - g,
                g - e, e - a, b - e, d - e, h - e, f - e,
                b - d, d - h, h - f, f - b
            ]);

        return universe[
            until(i => isSolution(universe[i]))(
                succ
            )(0)
        ];
    }

    // ---------------------- TEST -----------------------
    const main = () => {
        const
            firstSolution = solvedPuzzle(),
            [a, b, c, d, e, f, g, h] = firstSolution;

        return unlines(
            zipWith(
                a => n => a + ' = ' + n.toString()
            )(enumFromTo('A')('H'))(firstSolution)
            .concat([
                [],
                [a, b],
                [c, d, e, f],
                [g, h]
            ].map(
                xs => unwords(xs.map(show))
                .padStart(5, ' ')
            ))
        );
    }

    // ---------------- GENERIC FUNCTIONS ----------------

    // abs :: Num -> Num
    const abs =
        // Absolute value of a given number - without the sign.
        Math.abs;


    // all :: (a -> Bool) -> [a] -> Bool
    const all = p =>
        // True if p(x) holds for every x in xs.
        xs => [...xs].every(p);


    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (...fs) =>
        // A function defined by the right-to-left
        // composition of all the functions in fs.
        fs.reduce(
            (f, g) => x => f(g(x)),
            x => x
        );


    // enumFromTo :: Enum a => a -> a -> [a]
    const enumFromTo = m => n => {
        const [x, y] = [m, n].map(fromEnum),
            b = x + (isNaN(m) ? 0 : m - x);
        return Array.from({
            length: 1 + (y - x)
        }, (_, i) => toEnum(m)(b + i));
    };


    // fromEnum :: Enum a => a -> Int
    const fromEnum = x =>
        typeof x !== 'string' ? (
            x.constructor === Object ? (
                x.value
            ) : parseInt(Number(x))
        ) : x.codePointAt(0);


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


    // list :: StringOrArrayLike b => b -> [a]
    const list = xs =>
        // xs itself, if it is an Array,
        // or an Array derived from xs.
        Array.isArray(xs) ? (
            xs
        ) : Array.from(xs || []);


    // permutations :: [a] -> [[a]]
    const permutations = xs => (
        ys => ys.reduceRight(
            (a, y) => a.flatMap(
                ys => Array.from({
                    length: 1 + ys.length
                }, (_, i) => i)
                .map(n => ys.slice(0, n)
                    .concat(y)
                    .concat(ys.slice(n))
                )
            ), [
                []
            ]
        )
    )(list(xs));


    // show :: a -> String
    const show = x =>
        JSON.stringify(x);


    // succ :: Enum a => a -> a
    const succ = x =>
        1 + x;


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


    // toEnum :: a -> Int -> a
    const toEnum = e =>
        // The first argument is a sample of the type
        // allowing the function to make the right mapping
        x => ({
            'number': Number,
            'string': String.fromCodePoint,
            'boolean': Boolean,
            'object': v => e.min + v
        } [typeof e])(x);


    // unlines :: [String] -> String
    const unlines = xs =>
        // A single string formed by the intercalation
        // of a list of strings with the newline character.
        xs.join('\n');


    // until :: (a -> Bool) -> (a -> a) -> a -> a
    const until = p =>
        f => x => {
            let v = x;
            while (!p(v)) v = f(v);
            return v;
        };


    // unwords :: [String] -> String
    const unwords = xs =>
        // A space-separated string derived
        // from a list of words.
        xs.join(' ');


    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = f =>
        // Use of `take` and `length` here allows
        // zipping with non-finite lists
        // i.e. generators like cycle, repeat, iterate.
        xs => ys => {
            const n = Math.min(length(xs), length(ys));
            return Infinity > n ? (
                (([as, bs]) => Array.from({
                    length: n
                }, (_, i) => f(as[i])(
                    bs[i]
                )))([xs, ys].map(
                    compose(take(n), list)
                ))
            ) : zipWithGen(f)(xs)(ys);
        };

    return main();
})();
