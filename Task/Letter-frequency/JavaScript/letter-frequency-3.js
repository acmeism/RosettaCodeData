(() => {
    'use strict';


    // charCounts :: String -> [(Char, Int)]
    const charCounts = s =>
        sortBy(flip(comparing(snd)))(
            Object.entries(
                chars(s).reduce(
                    (a, c) => (
                        a[c] = 1 + (a[c] || 0),
                        a
                    ), {}
                )
            )
        );

    // ----------------------- TEST -----------------------
    // main :: IO ()
    const main = () =>
        either(msg => msg)(
            compose(
                unlines,
                map(JSON.stringify),
                charCounts
            )
        )(readFileLR('~/Code/charCount/miserables.txt'));


    // -----------------GENERIC FUNCTIONS -----------------

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


    // chars :: String -> [Char]
    const chars = s =>
        s.split('');


    // comparing :: (a -> b) -> (a -> a -> Ordering)
    const comparing = f =>
        x => y => {
            const
                a = f(x),
                b = f(y);
            return a < b ? -1 : (a > b ? 1 : 0);
        };

    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (...fs) =>
        fs.reduce(
            (f, g) => x => f(g(x)),
            x => x
        );

    // either :: (a -> c) -> (b -> c) -> Either a b -> c
    const either = fl =>
        fr => e => 'Either' === e.type ? (
            undefined !== e.Left ? (
                fl(e.Left)
            ) : fr(e.Right)
        ) : undefined;


    // flip :: (a -> b -> c) -> b -> a -> c
    const flip = f =>
        1 < f.length ? (
            (a, b) => f(b, a)
        ) : (x => y => f(y)(x));


    // map :: (a -> b) -> [a] -> [b]
    const map = f =>
        // The list obtained by applying f
        // to each element of xs.
        // (The image of xs under f).
        xs => (
            Array.isArray(xs) ? (
                xs
            ) : xs.split('')
        ).map(f);


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


    // unlines :: [String] -> String
    const unlines = xs =>
        // A single string formed by the intercalation
        // of a list of strings with the newline character.
        xs.join('\n');

    // MAIN ---
    return main();
})();
