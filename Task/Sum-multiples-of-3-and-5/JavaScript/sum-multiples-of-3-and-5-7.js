(() => {

    // sum35 :: Int -> Int
    const sum35 = n => {
        // The sum of all positive multiples of
        // 3 or 5 below n.
        const f = sumMults(n);
        return f(3) + f(5) - f(15);
    };


    // sumMults :: Int -> Int -> Int
    const sumMults = n =>
        // Area under straight line
        // between first multiple and last.
        factor => {
            const n1 = quot(n - 1)(factor);
            return quot(factor * n1 * (n1 + 1))(2);
        };

    // ------------------------- TEST --------------------------

    // main :: IO ()
    const main = () =>
        fTable('Sums for n = 10^1 thru 10^8:')(str)(str)(
            sum35
        )(
            enumFromTo(1)(8)
            .map(n => Math.pow(10, n))
        );


    // ------------------------ GENERIC ------------------------

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        n => !isNaN(m) ? (
            Array.from({
                length: 1 + n - m
            }, (_, i) => m + i)
        ) : enumFromTo_(m)(n);


    // quot :: Int -> Int -> Int
    const quot = n =>
        m => Math.floor(n / m);


    // ------------------------ DISPLAY ------------------------

    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (...fs) =>
        // A function defined by the right-to-left
        // composition of all the functions in fs.
        fs.reduce(
            (f, g) => x => f(g(x)),
            x => x
        );


    // fTable :: String -> (a -> String) -> (b -> String)
    //                      -> (a -> b) -> [a] -> String
    const fTable = s =>
        // Heading -> x display function ->
        //           fx display function ->
        //    f -> values -> tabular string
        xShow => fxShow => f => xs => {
            const
                ys = xs.map(xShow),
                w = Math.max(...ys.map(length));
            return s + '\n' + zipWith(
                a => b => a.padStart(w, ' ') + ' -> ' + b
            )(ys)(
                xs.map(x => fxShow(f(x)))
            ).join('\n');
        };


    // length :: [a] -> Int
    const length = xs =>
        // Returns Infinity over objects without finite
        // length. This enables zip and zipWith to choose
        // the shorter argument when one is non-finite,
        // like cycle, repeat etc
        'GeneratorFunction' !== xs.constructor.constructor.name ? (
            xs.length
        ) : Infinity;


    // list :: StringOrArrayLike b => b -> [a]
    const list = xs =>
        // xs itself, if it is an Array,
        // or an Array derived from xs.
        Array.isArray(xs) ? (
            xs
        ) : Array.from(xs);


    // str :: a -> String
    const str = x =>
        Array.isArray(x) && x.every(
            v => ('string' === typeof v) && (1 === v.length)
        ) ? (
            x.join('')
        ) : x.toString();


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


    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = f =>
        // Use of `take` and `length` here allows zipping with non-finite lists
        // i.e. generators like cycle, repeat, iterate.
        xs => ys => {
            const n = Math.min(length(xs), length(ys));
            return (([as, bs]) => Array.from({
                length: n
            }, (_, i) => f(as[i])(
                bs[i]
            )))([xs, ys].map(
                compose(take(n), list)
            ));
        };

    // ---
    return main();
})();
