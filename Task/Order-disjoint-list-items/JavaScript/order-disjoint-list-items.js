(() => {
    'use strict';

    // GENERIC FUNCTIONS

    // concatMap :: (a -> [b]) -> [a] -> [b]
    const concatMap = (f, xs) => [].concat.apply([], xs.map(f));

    // deleteFirst :: a -> [a] -> [a]
    const deleteFirst = (x, xs) =>
        xs.length > 0 ? (
            x === xs[0] ? (
                xs.slice(1)
            ) : [xs[0]].concat(deleteFirst(x, xs.slice(1)))
        ) : [];

    // flatten :: Tree a -> [a]
    const flatten = t => (t instanceof Array ? concatMap(flatten, t) : [t]);

    // unwords :: [String] -> String
    const unwords = xs => xs.join(' ');

    // words :: String -> [String]
    const words = s => s.split(/\s+/);

    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = (f, xs, ys) => {
        const ny = ys.length;
        return (xs.length <= ny ? xs : xs.slice(0, ny))
            .map((x, i) => f(x, ys[i]));
    };

    //------------------------------------------------------------------------

    // ORDER DISJOINT LIST ITEMS

    // disjointOrder :: [String] -> [String] -> [String]
    const disjointOrder = (ms, ns) =>
        flatten(
            zipWith(
                (a, b) => a.concat(b),
                segments(ms, ns),
                ns.concat('')
            )
        );

    // segments :: [String] -> [String] -> [String]
    const segments = (ms, ns) => {
        const dct = ms.reduce((a, x) => {
            const wds = a.words,
                blnFound = wds.indexOf(x) !== -1;

            return {
                parts: a.parts.concat(blnFound ? [a.current] : []),
                current: blnFound ? [] : a.current.concat(x),
                words: blnFound ? deleteFirst(x, wds) : wds,
            };
        }, {
            words: ns,
            parts: [],
            current: []
        });

        return dct.parts.concat([dct.current]);
    };

    // -----------------------------------------------------------------------
    // FORMATTING TEST OUTPUT

    // transpose :: [[a]] -> [[a]]
    const transpose = xs =>
        xs[0].map((_, iCol) => xs.map((row) => row[iCol]));

    // maximumBy :: (a -> a -> Ordering) -> [a] -> a
    const maximumBy = (f, xs) =>
        xs.reduce((a, x) => a === undefined ? x : (
            f(x, a) > 0 ? x : a
        ), undefined);

    // 2 or more arguments
    // curry :: Function -> Function
    const curry = (f, ...args) => {
        const intArgs = f.length,
            go = xs =>
            xs.length >= intArgs ? (
                f.apply(null, xs)
            ) : function () {
                return go(xs.concat([].slice.apply(arguments)));
            };
        return go([].slice.call(args, 1));
    };

    // justifyLeft :: Int -> Char -> Text -> Text
    const justifyLeft = (n, cFiller, strText) =>
        n > strText.length ? (
            (strText + replicateS(n, cFiller))
            .substr(0, n)
        ) : strText;

    // replicateS :: Int -> String -> String
    const replicateS = (n, s) => {
        let v = s,
            o = '';
        if (n < 1) return o;
        while (n > 1) {
            if (n & 1) o = o.concat(v);
            n >>= 1;
            v = v.concat(v);
        }
        return o.concat(v);
    };

    // -----------------------------------------------------------------------

    // TEST
    return transpose(transpose([{
                M: 'the cat sat on the mat',
                N: 'mat cat'
            }, {
                M: 'the cat sat on the mat',
                N: 'cat mat'
            }, {
                M: 'A B C A B C A B C',
                N: 'C A C A'
            }, {
                M: 'A B C A B D A B E',
                N: 'E A D A'
            }, {
                M: 'A B',
                N: 'B'
            }, {
                M: 'A B',
                N: 'B A'
            }, {
                M: 'A B B A',
                N: 'B A'
            }].map(dct => [
                dct.M, dct.N,
                unwords(disjointOrder(words(dct.M), words(dct.N)))
            ]))
            .map(col => {
                const width = maximumBy((a, b) => a.length > b.length, col)
                    .length;
                return col.map(curry(justifyLeft)(width, ' '));
            }))
        .map(
            ([a, b, c]) => a + '  ->  ' + b + '  ->  ' + c
        )
        .join('\n');
})();
