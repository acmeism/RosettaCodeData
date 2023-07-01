(() => {
    'use strict';

    // ------------------ DRAGON CURVE -------------------

    // dragonCurve :: [[Int]] -> [[Int]]
    const dragonCurve = xs => {
        const
            pivot = op => map(
                zipWith(op)(last(xs))
            ),
            r90 = [
                [0, 1],
                [-1, 0]
            ];
        return compose(
            append(xs),
            pivot(add),
            flip(matrixMultiply)(r90),
            pivot(subtract),
            reverse,
            init
        )(xs);
    };


    // ---------------------- TEST -----------------------
    // main :: IO ()
    const main = () =>
        // SVG of 12th iteration.
        console.log(
            svgFromPointLists(512)(512)(
                index(iterate(dragonCurve)([
                    [0, 0],
                    [0, -1]
                ]))(12)
            )
        );


    // ----------------------- SVG -----------------------

    // svgFromPointLists :: Int -> Int ->
    // [[(Int, Int)]] -> String
    const svgFromPointLists = cw => ch =>
        xyss => {
            const
                polyline = xs =>
                `<polyline points="${unwords(concat(xs).map(showJSON))}"/>`,
                [x, y, mx, my] = ap([minimum, maximum])(
                    Array.from(unzip(concat(xyss)))
                ),
                [wd, hd] = map(x => Math.floor(x / 10))([
                    mx - x, my - y
                ]);
            return unlines([
                '<?xml version="1.0" encoding="UTF-8"?>',
                unwords([
                    '<svg',
                    `width="${cw}" height="${ch}"`,
                    `viewBox="${x - wd} ${y - hd} ${12 * wd} ${12 * hd}"`,
                    'xmlns="http://www.w3.org/2000/svg">'
                ]),
                '<g stroke-width="0.2" stroke="red" fill="none">',
                unlines(map(polyline)(xyss)),
                '</g>',
                '</svg>'
            ]);
        };


    // ---------------- GENERIC FUNCTIONS ----------------

    // Just :: a -> Maybe a
    const Just = x => ({
        type: 'Maybe',
        Nothing: false,
        Just: x
    });


    // Nothing :: Maybe a
    const Nothing = () => ({
        type: 'Maybe',
        Nothing: true,
    });


    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = a =>
        b => ({
            type: 'Tuple',
            '0': a,
            '1': b,
            length: 2
        });


    // add (+) :: Num a => a -> a -> a
    const add = a =>
        // Curried addition.
        b => a + b;


    // ap (<*>) :: [(a -> b)] -> [a] -> [b]
    const ap = fs =>
        // The sequential application of each of a list
        // of functions to each of a list of values.
        xs => fs.flatMap(
            f => xs.map(f)
        );

    // append (++) :: [a] -> [a] -> [a]
    // append (++) :: String -> String -> String
    const append = xs =>
        // A list or string composed by
        // the concatenation of two others.
        ys => xs.concat(ys);


    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (...fs) =>
        fs.reduce(
            (f, g) => x => f(g(x)),
            x => x
        );


    // concat :: [[a]] -> [a]
    const concat = xs => [].concat(...xs);


    // dotProduct :: Num a => [[a]] -> [[a]] -> [[a]]
    const dotProduct = xs =>
        compose(sum, zipWith(mul)(xs));


    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        n => Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);


    // flip :: (a -> b -> c) -> b -> a -> c
    const flip = f =>
        x => y => f(y)(x);


    // index (!!) :: [a] -> Int -> Maybe a
    // index (!!) :: Generator (a) -> Int -> Maybe a
    // index (!!) :: String -> Int -> Maybe Char
    const index = xs =>
        i => (
            drop(i)(xs),
            take(1)(xs)
        );


    // drop :: Int -> [a] -> [a]
    // drop :: Int -> Generator [a] -> Generator [a]
    // drop :: Int -> String -> String
    const drop = n =>
        xs => Infinity > length(xs) ? (
            xs.slice(n)
        ) : (take(n)(xs), xs);


    // init :: [a] -> [a]
    const init = xs =>
        // All elements of a list except the last.
        0 < xs.length ? (
            xs.slice(0, -1)
        ) : undefined;


    // iterate :: (a -> a) -> a -> Gen [a]
    const iterate = f =>
        function* (x) {
            let v = x;
            while (true) {
                yield(v);
                v = f(v);
            }
        };


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
        xs => xs.map(f);


    // matrixMultiply :: Num a => [[a]] -> [[a]] -> [[a]]
    const matrixMultiply = a =>
        b => {
            const cols = transpose(b);
            return map(
                compose(
                    flip(map)(cols),
                    dotProduct
                )
            )(a);
        };

    // minimum :: Ord a => [a] -> a
    const minimum = xs =>
        0 < xs.length ? (
            xs.slice(1)
            .reduce((a, x) => x < a ? x : a, xs[0])
        ) : undefined;


    // maximum :: Ord a => [a] -> a
    const maximum = xs =>
        // The largest value in a non-empty list.
        0 < xs.length ? (
            xs.slice(1).reduce(
                (a, x) => x > a ? (
                    x
                ) : a, xs[0]
            )
        ) : undefined;


    // mul (*) :: Num a => a -> a -> a
    const mul = a =>
        b => a * b;


    // reverse :: [a] -> [a]
    const reverse = xs =>
        xs.slice(0).reverse();


    // showJSON :: a -> String
    const showJSON = x =>
        // Indented JSON representation of the value x.
        JSON.stringify(x, null, 2);


    // subtract :: Num -> Num -> Num
    const subtract = x =>
        y => y - x;


    // sum :: [Num] -> Num
    const sum = xs =>
        // The numeric sum of all values in xs.
        xs.reduce((a, x) => a + x, 0);


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


    // transpose :: [[a]] -> [[a]]
    const transpose = rows =>
        // The columns of the input transposed
        // into new rows.
        // Simpler version of transpose, assuming input
        // rows of even length.
        0 < rows.length ? rows[0].map(
            (x, i) => rows.flatMap(
                x => x[i]
            )
        ) : [];


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


    // unwords :: [String] -> String
    const unwords = xs =>
        // A space-separated string derived
        // from a list of words.
        xs.join(' ');


    // unzip :: [(a,b)] -> ([a],[b])
    const unzip = xys =>
        xys.reduce(
            (ab, xy) => Tuple(ab[0].concat(xy[0]))(
                ab[1].concat(xy[1])
            ),
            Tuple([])([])
        );


    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = f =>
        // A list constructed by zipping with a
        // custom function, rather than with the
        // default tuple constructor.
        xs => ys => {
            const
                lng = Math.min(length(xs), length(ys)),
                vs = take(lng)(ys);
            return take(lng)(xs)
                .map((x, i) => f(x)(vs[i]));
        };

    // MAIN ---
    return main();
})();
