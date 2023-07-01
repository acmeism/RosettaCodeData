(() => {
    'use strict';

    // largestAnagramGroups :: FilePath -> Either String [[String]]
    const largestAnagramGroups = fp =>
        either(msg => msg)(strLexicon => {
            const
                groups = sortBy(flip(comparing(length)))(
                    groupBy(on(eq)(fst))(
                        sortBy(comparing(fst))(
                            strLexicon
                            .split(/[\r\n]/)
                            .map(w => [w.split('').sort().join(''), w])
                        )
                    )
                ),
                maxSize = groups[0].length;
            return map(map(snd))(
                takeWhile(x => maxSize === x.length)(
                    groups
                )
            )
        })(readFileLR(fp));

    // ------------------------TEST------------------------
    const main = () =>
        console.log(JSON.stringify(
            largestAnagramGroups('unixdict.txt'),
            null, 2
        ))


    // -----------------GENERIC FUNCTIONS------------------

    // Left :: a -> Either a b
    const Left = x => ({
        type: 'Either',
        Left: x
    });

    // Right :: b -> Either a b
    const Right = x => ({
        type: 'Either',
        Right: x
    });

    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = a =>
        b => ({
            type: 'Tuple',
            '0': a,
            '1': b,
            length: 2
        });

    // comparing :: (a -> b) -> (a -> a -> Ordering)
    const comparing = f =>
        x => y => {
            const
                a = f(x),
                b = f(y);
            return a < b ? -1 : (a > b ? 1 : 0);
        };

    // either :: (a -> c) -> (b -> c) -> Either a b -> c
    const either = fl =>
        fr => e => 'Either' === e.type ? (
            undefined !== e.Left ? (
                fl(e.Left)
            ) : fr(e.Right)
        ) : undefined;

    // eq (==) :: Eq a => a -> a -> Bool
    const eq = a =>
        // True when a and b are equivalent.
        b => a === b

    // flip :: (a -> b -> c) -> b -> a -> c
    const flip = f =>
        1 < f.length ? (
            (a, b) => f(b, a)
        ) : (x => y => f(y)(x));

    // fst :: (a, b) -> a
    const fst = tpl =>
        // First member of a pair.
        tpl[0];

    // groupBy :: (a -> a -> Bool) -> [a] -> [[a]]
    const groupBy = fEq => xs =>
        // // Typical usage: groupBy(on(eq)(f), xs)
        0 < xs.length ? (() => {
            const
                tpl = xs.slice(1).reduce(
                    (gw, x) => {
                        const
                            gps = gw[0],
                            wkg = gw[1];
                        return fEq(wkg[0])(x) ? (
                            Tuple(gps)(wkg.concat([x]))
                        ) : Tuple(gps.concat([wkg]))([x]);
                    },
                    Tuple([])([xs[0]])
                );
            return tpl[0].concat([tpl[1]])
        })() : [];

    // length :: [a] -> Int
    const length = xs => xs.length

    // map :: (a -> b) -> [a] -> [b]
    const map = f =>
        // The list obtained by applying f
        // to each element of xs.
        // (The image of xs under f).
        xs => xs.map(f);

    // on :: (b -> b -> c) -> (a -> b) -> a -> a -> c
    const on = f =>
        // e.g. sortBy(on(compare,length), xs)
        g => a => b => f(g(a))(g(b));

    // readFileLR :: FilePath -> Either String IO String
    const readFileLR = fp => {
        const
            e = $(),
            ns = $.NSString
            .stringWithContentsOfFileEncodingError(
                $(fp).stringByStandardizingPath,
                $.NSUTF8StringEncoding,
                e
            );
        return ns.isNil() ? (
            Left(ObjC.unwrap(e.localizedDescription))
        ) : Right(ObjC.unwrap(ns));
    };

    // snd :: (a, b) -> b
    const snd = tpl => tpl[1];

    // sortBy :: (a -> a -> Ordering) -> [a] -> [a]
    const sortBy = f =>
        xs => xs.slice()
        .sort((a, b) => f(a)(b));

    // takeWhile :: (a -> Bool) -> [a] -> [a]
    // takeWhile :: (Char -> Bool) -> String -> String
    const takeWhile = p =>
        xs => {
            const lng = xs.length;
            return 0 < lng ? xs.slice(
                0,
                until(i => lng === i || !p(xs[i]))(
                    i => 1 + i
                )(0)
            ) : [];
        };

    // until :: (a -> Bool) -> (a -> a) -> a -> a
    const until = p => f => x => {
        let v = x;
        while (!p(v)) v = f(v);
        return v;
    };

    // MAIN ---
    return main();
})();
