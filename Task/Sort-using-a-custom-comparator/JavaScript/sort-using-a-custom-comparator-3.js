(() => {
    'use strict';

    // main :: IO ()
    const main = () => {
        const
            lengthThenAZ = mappendOrd(
                comparing(length),
                comparing(toLower)
            ),
            descLengthThenAZ = mappendOrd(
                flip(comparing(length)),
                comparing(toLower)
            );

        console.log(
            apList(apList([sortBy])([
                lengthThenAZ,
                descLengthThenAZ
            ]))([
                [
                    "Here", "are", "some", "sample",
                    "strings", "to", "be", "sorted"
                ]
            ]).map(unlines).join('\n\n')
        );
    };

    // GENERIC FUNCTIONS ----------------------------------

    // apList (<*>) :: [a -> b] -> [a] -> [b]
    const apList = fs => xs =>
        // The application of each of a list of functions,
        // to each of a list of values.
        fs.flatMap(
            f => xs.flatMap(x => [f(x)])
        );

    // comparing :: (a -> b) -> (a -> a -> Ordering)
    const comparing = f =>
        (x, y) => {
            const
                a = f(x),
                b = f(y);
            return a < b ? -1 : (a > b ? 1 : 0);
        };

    // flip :: (a -> b -> c) -> b -> a -> c
    const flip = f =>
        1 < f.length ? (
            (a, b) => f(b, a)
        ) : (x => y => f(y)(x));

    // length :: [a] -> Int
    const length = xs =>
        (Array.isArray(xs) || 'string' === typeof xs) ? (
            xs.length
        ) : Infinity;

    // mappendOrd (<>) :: Ordering -> Ordering -> Ordering
    const mappendOrd = (a, b) => a !== 0 ? a : b;

    // sortBy :: (a -> a -> Ordering) -> [a] -> [a]
    const sortBy = f => xs =>
        xs.slice()
        .sort(f);

    // toLower :: String -> String
    const toLower = s => s.toLocaleLowerCase();

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // MAIN ---
    return main();
})();
