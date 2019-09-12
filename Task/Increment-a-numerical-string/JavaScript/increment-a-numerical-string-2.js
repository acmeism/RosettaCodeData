(() => {
    'use strict';

    // succString :: Bool -> String -> String
    const succString = blnPruned => s => {
        const go = w => {
            const
                v = w.includes('.') ? (
                    parseFloat(w)
                ) : parseInt(w);
            return isNaN(v) ? (
                blnPruned ? [] : [w]
            ) : [(1 + v).toString()];
        };
        return unwords(concatMap(go, words(s)));
    };

    // TEST -----------------------------------------------
    const main = () =>
        console.log(
            unlines(
                ap(
                    map(succString, [true, false]),
                    ['41 pine martens in 1491.3 -1.5 mushrooms ≠ 136']
                )
            )
        );


    // GENERIC FUNCTIONS ----------------------------------

    // Each member of a list of functions applied to each
    // of a list of arguments, deriving a list of new values.

    // ap (<*>) :: [(a -> b)] -> [a] -> [b]
    const ap = (fs, xs) => //
        fs.reduce((a, f) => a.concat(
            xs.reduce((a, x) => a.concat([f(x)]), [])
        ), []);

    // concatMap :: (a -> [b]) -> [a] -> [b]
    const concatMap = (f, xs) =>
        xs.reduce((a, x) => a.concat(f(x)), []);

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f);

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // unwords :: [String] -> String
    const unwords = xs => xs.join(' ');

    // words :: String -> [String]
    const words = s => s.split(/\s+/);

    // MAIN ---
    return main();
})();
