(() => {
    "use strict";

    // -------------- LONGEST COMMON PREFIX --------------

    // lcp :: (Eq a) => [[a]] -> [a]
    const lcp = xs => {
        const go = ws =>
            ws.some(isNull) ? (
                []
            ) : [ws.map(head)].concat(
                go(ws.map(tail))
            );

        return takeWhile(allSame)(
                go(xs.map(s => [...s]))
            )
            .map(head)
            .join("");

    };


    // ---------------------- TEST -----------------------

    // main :: IO ()
    const main = () => [
        ["interspecies", "interstellar", "interstate"],
        ["throne", "throne"],
        ["throne", "dungeon"],
        ["cheese"],
        [""],
        ["prefix", "suffix"],
        ["foo", "foobar"]
    ].map(showPrefix).join("\n");


    // showPrefix :: [String] -> String
    const showPrefix = xs =>
        `${show(xs)}  -> ${show(lcp(xs))}`;


    // ---------------- GENERIC FUNCTIONS ----------------

    // allSame :: [a] -> Bool
    const allSame = xs =>
        // True if xs has less than 2 items, or every item
        // in the tail of the list is identical to the head.
        2 > xs.length || (() => {
            const [h, ...t] = xs;

            return t.every(x => h === x);
        })();


    // head :: [a] -> a
    const head = xs =>
        xs.length ? (
            xs[0]
        ) : undefined;


    // isNull :: [a] -> Bool
    // isNull :: String -> Bool
    const isNull = xs =>
        // True if xs is empty.
        1 > xs.length;


    // show :: a -> String
    const show = JSON.stringify;


    // tail :: [a] -> [a]
    const tail = xs =>
        0 < xs.length ? (
            xs.slice(1)
        ) : [];


    // takeWhile :: (a -> Bool) -> [a] -> [a]
    const takeWhile = p =>
        xs => {
            const i = xs.findIndex(x => !p(x));

            return -1 !== i ? (
                xs.slice(0, i)
            ) : xs;
        };


    // MAIN ---
    return main();
})();
