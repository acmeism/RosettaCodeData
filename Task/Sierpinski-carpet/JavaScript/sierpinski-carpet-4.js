(() => {
    'use strict';

    // weave :: [String] -> [String]
    const weave = xs => {
        const f = zipWith(append);
        return concatMap(
            x => f(f(xs)(x))(xs)
        )([
            xs,
            map(x => replicate(length(x))(' '))(
                xs
            ),
            xs
        ]);
    };

    // TEST -----------------------------------------------
    const main = () => {
        const
            sierp = n => unlines(
                take(1 + n, iterate(weave, ['\u2588']))[n]
            ),
            carpet = sierp(2);
        return (
            // console.log(carpet),
            carpet
        );
    };


    // GENERIC ABSTRACTIONS -------------------------------

    // append (++) :: [a] -> [a] -> [a]
    // append (++) :: String -> String -> String
    const append = xs => ys => xs.concat(ys);

    // concatMap :: (a -> [b]) -> [a] -> [b]
    const concatMap = f => xs =>
        xs.reduce((a, x) => a.concat(f(x)), []);

    // iterate :: (a -> a) -> a -> Gen [a]
    function* iterate(f, x) {
        let v = x;
        while (true) {
            yield(v);
            v = f(v);
        }
    }

    // Returns Infinity over objects without finite length
    // this enables zip and zipWith to choose the shorter
    // argument when one is non-finite, like cycle, repeat etc

    // length :: [a] -> Int
    const length = xs => xs.length || Infinity;

    // map :: (a -> b) -> [a] -> [b]
    const map = f => xs => xs.map(f);

    // replicate :: Int -> String -> String
    const replicate = n => s => s.repeat(n);

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

    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = f => xs => ys => {
        const
            lng = Math.min(length(xs), length(ys)),
            as = take(lng, xs),
            bs = take(lng, ys);
        return Array.from({
            length: lng
        }, (_, i) => f(as[i])(bs[i]));
    };

    // MAIN -----------------------------------------------
    return main();
})();
