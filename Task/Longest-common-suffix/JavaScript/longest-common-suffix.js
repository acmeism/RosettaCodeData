(() => {
    'use strict';

    // --------------- LONGEST COMMON SUFFIX ---------------

    // longestCommonSuffix :: [String] -> String
    const longestCommonSuffix = xs => (
            1 < xs.length ? (
                takeWhile(allSame)(
                    transpose(xs.map(reverse))
                ).map(fst).reverse()
            ) : xs
        ).join('');


    // ----------------------- TEST ------------------------
    const main = () =>
        fTable('Longest common suffix:\n')(unwords)(
            quoted("'")
        )(longestCommonSuffix)([
            'throne saxophone tone',
            'prefix suffix infix',
            'remark spark aardvark lark',
            'ectoplasm banana brick'
        ].map(words))


    // ----------------- GENERIC FUNCTIONS -----------------

    // allSame :: [a] -> Bool
    const allSame = xs =>
        2 > xs.length || (
            h => xs.slice(1).every(x => h === x)
        )(xs[0]);


    // fst :: (a, b) -> a
    const fst = tpl =>
        // First member of a pair.
        tpl[0];


    // fTable :: String -> (a -> String) ->
    // (b -> String) -> (a -> b) -> [a] -> String
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
        'GeneratorFunction' !== xs.constructor
        .constructor.name ? xs.length : Infinity;


    // map :: (a -> b) -> [a] -> [b]
    const map = f =>
        // The list obtained by applying f
        // to each element of xs.
        // (The image of xs under f).
        xs => [...xs].map(f);


    // reverse :: [a] -> [a]
    const reverse = xs =>
        'string' !== typeof xs ? (
            xs.slice(0).reverse()
        ) : xs.split('').reverse().join('');


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


    // takeWhile :: (a -> Bool) -> [a] -> [a]
    // takeWhile :: (Char -> Bool) -> String -> String
    const takeWhile = p =>
        xs => (
            n => xs.slice(
                0, 0 < n ? until(
                    i => n === i || !p(xs[i])
                )(i => 1 + i)(0) : 0
            )
        )(xs.length);


    // transpose :: [[a]] -> [[a]]
    const transpose = xss => {
        // If some of the rows are shorter than the following rows,
        // their elements are skipped:
        // > transpose [[10,11],[20],[],[30,31,32]] == [[10,20,30],[11,31],[32]]
        const go = xss =>
            0 < xss.length ? (() => {
                const
                    h = xss[0],
                    t = xss.slice(1);
                return 0 < h.length ? [
                    [h[0]].concat(t.reduce(
                        (a, xs) => a.concat(
                            0 < xs.length ? (
                                [xs[0]]
                            ) : []
                        ),
                        []
                    ))
                ].concat(go([h.slice(1)].concat(
                    t.map(xs => xs.slice(1))
                ))) : go(t);
            })() : [];
        return go(xss);
    };


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


    // quoted :: Char -> String -> String
    const quoted = c =>
        // A string flanked on both sides
        // by a specified quote character.
        s => c + s + c;

    // words :: String -> [String]
    const words = s =>
        // List of space-delimited sub-strings.
        s.split(/\s+/);


    // zipWithList :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = f =>
        // A list constructed by zipping with a
        // custom function, rather than with the
        // default tuple constructor.
        xs => ys => ((xs_, ys_) => {
            const lng = Math.min(length(xs_), length(ys_));
            return take(lng)(xs_).map(
                (x, i) => f(x)(ys_[i])
            );
        })([...xs], [...ys]);

    // MAIN ---
    return main();
})();
