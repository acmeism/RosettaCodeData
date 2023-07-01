(() => {
    'use strict';

    // ------------------ HUMBLE NUMBERS -------------------

    // humbles :: () -> [Int]
    function* humbles() {
        // A non-finite stream of Humble numbers.
        // OEIS A002473
        const hs = new Set([1]);
        while (true) {
            let nxt = Math.min(...hs)
            yield nxt;
            hs.delete(nxt);
            [2, 3, 5, 7].forEach(
                x => hs.add(nxt * x)
            );
        }
    };

    // ----------------------- TEST ------------------------
    // main :: IO ()
    const main = () => {
        console.log('First 50 humble numbers:\n')
        chunksOf(10)(take(50)(humbles())).forEach(
            row => console.log(
                concat(row.map(compose(justifyRight(4)(' '), str)))
            )
        );
        console.log(
            '\nCounts of humble numbers of given digit lengths:'
        );
        const
            counts = map(length)(
                group(takeWhileGen(x => 11 > x)(
                    fmapGen(x => str(x).length)(
                        humbles()
                    )
                ))
            );
        console.log(
            fTable('\n')(str)(str)(
                i => counts[i - 1]
            )(enumFromTo(1)(10))
        );
    };


    // ----------------- GENERIC FUNCTIONS -----------------

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
        // A function defined by the right-to-left
        // composition of all the functions in fs.
        fs.reduce(
            (f, g) => x => f(g(x)),
            x => x
        );


    // concat :: [[a]] -> [a]
    // concat :: [String] -> String
    const concat = xs =>
        0 < xs.length ? (() => {
            const unit = 'string' !== typeof xs[0] ? (
                []
            ) : '';
            return unit.concat.apply(unit, xs);
        })() : [];


    // enumFromThenTo :: Int -> Int -> Int -> [Int]
    const enumFromThenTo = x1 =>
        x2 => y => {
            const d = x2 - x1;
            return Array.from({
                length: Math.floor(y - x2) / d + 2
            }, (_, i) => x1 + (d * i));
        };


    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        n => Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);


    // fTable :: String -> (a -> String) -> (b -> String)
    //                      -> (a -> b) -> [a] -> String
    const fTable = s => xShow => fxShow => f => xs => {
        // Heading -> x display function ->
        //           fx display function ->
        //    f -> values -> tabular string
        const
            ys = xs.map(xShow),
            w = Math.max(...ys.map(length));
        return s + '\n' + zipWith(
            a => b => a.padStart(w, ' ') + ' -> ' + b
        )(ys)(
            xs.map(x => fxShow(f(x)))
        ).join('\n');
    };


    // fmapGen <$> :: (a -> b) -> Gen [a] -> Gen [b]
    const fmapGen = f =>
        function*(gen) {
            let v = take(1)(gen);
            while (0 < v.length) {
                yield(f(v[0]))
                v = take(1)(gen)
            }
        };


    // group :: Eq a => [a] -> [[a]]
    const group = xs => {
        // A list of lists, each containing only equal elements,
        // such that the concatenation of these lists is xs.
        const go = xs =>
            0 < xs.length ? (() => {
                const
                    h = xs[0],
                    i = xs.findIndex(x => h !== x);
                return i !== -1 ? (
                    [xs.slice(0, i)].concat(go(xs.slice(i)))
                ) : [xs];
            })() : [];
        const v = go(list(xs));
        return 'string' === typeof xs ? (
            v.map(x => x.join(''))
        ) : v;
    };


    // justifyRight :: Int -> Char -> String -> String
    const justifyRight = n =>
        // The string s, preceded by enough padding (with
        // the character c) to reach the string length n.
        c => s => n > s.length ? (
            s.padStart(n, c)
        ) : s;


    // length :: [a] -> Int
    const length = xs =>
        // Returns Infinity over objects without finite length.
        // This enables zip and zipWith to choose the shorter
        // argument when one is non-finite, like cycle, repeat etc
        (Array.isArray(xs) || 'string' === typeof xs) ? (
            xs.length
        ) : Infinity;


    // list :: StringOrArrayLike b => b -> [a]
    const list = xs =>
        // xs itself, if it is an Array,
        // or an Array derived from xs.
        Array.isArray(xs) ? (
            xs
        ) : Array.from(xs);


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
    const take = n => xs =>
        'GeneratorFunction' !== xs.constructor.constructor.name ? (
            xs.slice(0, n)
        ) : [].concat.apply([], Array.from({
            length: n
        }, () => {
            const x = xs.next();
            return x.done ? [] : [x.value];
        }));


    // takeWhileGen :: (a -> Bool) -> Gen [a] -> [a]
    const takeWhileGen = p => xs => {
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


    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = f =>
        // Use of `take` and `length` here allows zipping with non-finite lists
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

    // MAIN ---
    return main();
})();
