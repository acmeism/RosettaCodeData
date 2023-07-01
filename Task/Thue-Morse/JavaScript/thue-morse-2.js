(() => {
    'use strict';

    // thueMorsePrefixes :: () -> [[Int]]
    const thueMorsePrefixes = () =>
        iterate(
            ap(append)(
                map(x => 1 - x)
            )
        )([0]);

    // ----------------------- TEST -----------------------
    const main = () =>
        // Fifth iteration.
        // 2 ^ 5 = 32 terms of the Thue-Morse sequence.
        showList(
            index(thueMorsePrefixes())(
                5
            )
        );


    // ---------------- GENERIC FUNCTIONS -----------------

    // ap :: (a -> b -> c) -> (a -> b) -> a -> c
    const ap = f =>
        // Applicative instance for functions.
        // f(x) applied to g(x).
        g => x => f(x)(
            g(x)
        );


    // append (++) :: [a] -> [a] -> [a]
    // append (++) :: String -> String -> String
    const append = xs =>
        // A list or string composed by
        // the concatenation of two others.
        ys => xs.concat(ys);


    // index (!!) :: Generator (Int, a) -> Int -> Maybe a
    const index = xs =>
        i => (take(i)(xs), xs.next().value);


    // iterate :: (a -> a) -> a -> Gen [a]
    const iterate = f =>
        function*(x) {
            let v = x;
            while (true) {
                yield(v);
                v = f(v);
            }
        };


    // map :: (a -> b) -> [a] -> [b]
    const map = f =>
        // The list obtained by applying f
        // to each element of xs.
        // (The image of xs under f).
        xs => xs.map(f);


    // showList :: [a] -> String
    const showList = xs =>
        '[' + xs.map(x => x.toString())
        .join(',')
        .replace(/[\"]/g, '') + ']';


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

    // MAIN ---
    return main();
})();
