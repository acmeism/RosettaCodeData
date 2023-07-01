(() => {
    'use strict';

    // ------------------ GAPFUL NUMBERS -------------------

    // isGapful :: Int -> Bool
    const isGapful = n =>
        compose(
            x => 0 === n % x,
            JSON.parse,
            concat,
            ap([head, last]),
            x => [x],
            JSON.stringify
        )(n);

    // ----------------------- TEST ------------------------
    const main = () =>
        unlines([
            'First 30 gapful numbers >= 100',
            'First 15 Gapful numbers >= 1E6',
            'First 10 Gapful numbers >= 1E9'
        ].map(k => {
            const
                ws = words(k),
                mn = [1, 5].map(
                    i => JSON.parse(ws[i])
                );
            return k + ':\n\n' + showList(
                take(mn[0])(
                    filterGen(isGapful)(
                        enumFrom(mn[1])
                    )
                )
            );
        }));


    // ----------------- GENERIC FUNCTIONS -----------------

    // ap (<*>) :: [(a -> b)] -> [a] -> [b]
    const ap = fs =>
        // The sequential application of each of a list
        // of functions to each of a list of values.
        xs => fs.flatMap(f => xs.map(x => f(x)));


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
    const concat = xs => (
        ys => 0 < ys.length ? (
            ys.every(Array.isArray) ? (
                []
            ) : ''
        ).concat(...ys) : ys
    )(list(xs));


    // enumFrom :: Enum a => a -> [a]
    function* enumFrom(x) {
        // A non-finite succession of enumerable
        // values, starting with the value x.
        let v = x;
        while (true) {
            yield v;
            v = succ(v);
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


    // filterGen :: (a -> Bool) -> Gen [a] -> [a]
    const filterGen = p => xs => {
        function* go() {
            let x = xs.next();
            while (!x.done) {
                let v = x.value;
                if (p(v)) {
                    yield v;
                }
                x = xs.next();
            }
        }
        return go(xs);
    };


    // head :: [a] -> a
    const head = xs => (
        ys => ys.length ? (
            ys[0]
        ) : undefined
    )(list(xs));


    // last :: [a] -> a
    const last = xs => (
        // The last item of a list.
        ys => 0 < ys.length ? (
            ys.slice(-1)[0]
        ) : undefined
    )(list(xs));


    // list :: StringOrArrayLike b => b -> [a]
    const list = xs =>
        // xs itself, if it is an Array,
        // or an Array derived from xs.
        Array.isArray(xs) ? (
            xs
        ) : Array.from(xs || []);


    // showList :: [a] -> String
    const showList = xs =>
        unlines(
            chunksOf(5)(xs).map(
                ys => '\t' + ys.join(',')
            )
        ) + '\n';


    // succ :: Enum a => a -> a
    const succ = x => {
        const t = typeof x;
        return 'number' !== t ? (() => {
            const [i, mx] = [x, maxBound(x)].map(fromEnum);
            return i < mx ? (
                toEnum(x)(1 + i)
            ) : Error('succ :: enum out of range.')
        })() : x < Number.MAX_SAFE_INTEGER ? (
            1 + x
        ) : Error('succ :: Num out of range.')
    };


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


    // words :: String -> [String]
    const words = s =>
        // List of space-delimited sub-strings.
        s.split(/\s+/);

    // MAIN ---
    return main();
})();
