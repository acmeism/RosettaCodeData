(() => {
    'use strict';

    // -- WORDS WITH ALTERNATING VOWELS AND CONSONANTS ---

    // isLongAlternator :: String -> Bool
    const isLongAlternator = s =>
        9 < s.length && all(
            ab => isVowel(ab[0]) !== isVowel(ab[1])
        )(
            zip(s)(s.slice(1))
        );

    // isVowel :: Char -> Bool
    const isVowel = c =>
        'aeiou'.includes(c);


    // ---------------------- TEST -----------------------
    // main :: IO ()
    const main = () => {
        const
            matches = lines(
                readFile('unixdict.txt')
            ).filter(isLongAlternator);

        return `${matches.length} matches:\n\n` + (
            inColumns(4)(matches)
        );
    };

    // ------------------- FORMATTING --------------------

    // inColumns :: Int -> [String] -> String
    const inColumns = n =>
        xs => (
            w => unlines(
                chunksOf(n)(
                    xs.map(justifyLeft(w)(' '))
                )
                .map(unwords)
            )
        )(
            maximum(xs.map(length))
        );

    // --------------------- GENERIC ---------------------

    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = a =>
        b => ({
            type: 'Tuple',
            '0': a,
            '1': b,
            length: 2
        });


    // all :: (a -> Bool) -> [a] -> Bool
    const all = p =>
        // True if p(x) holds for every x in xs.
        xs => [...xs].every(p);


    // chunksOf :: Int -> [a] -> [[a]]
    const chunksOf = n => {
        // xs split into sublists of length n.
        // The last sublist will be short if n
        // does not evenly divide the length of xs .
        const go = xs => {
            const
                chunk = xs.slice(0, n),
                rest = xs.slice(n);
            return 0 < chunk.length ? (
                [chunk].concat(go(rest))
            ) : [];
        };
        return go;
    };


    // justifyLeft :: Int -> Char -> String -> String
    const justifyLeft = n =>
        // The string s, followed by enough padding (with
        // the character c) to reach the string length n.
        c => s => n > s.length ? (
            s.padEnd(n, c)
        ) : s;


    // length :: [a] -> Int
    const length = xs =>
        // Returns Infinity over objects without finite
        // length. This enables zip and zipWith to choose
        // the shorter argument when one is non-finite,
        // like cycle, repeat etc
        'GeneratorFunction' !== xs.constructor
        .constructor.name ? (
            xs.length
        ) : Infinity;


    // lines :: String -> [String]
    const lines = s =>
        // A list of strings derived from a single
        // string delimited by newline and or CR.
        0 < s.length ? (
            s.split(/[\r\n]+/)
        ) : [];


    // list :: StringOrArrayLike b => b -> [a]
    const list = xs =>
        // xs itself, if it is an Array,
        // or an Array derived from xs.
        Array.isArray(xs) ? (
            xs
        ) : Array.from(xs || []);


    // maximum :: Ord a => [a] -> a
    const maximum = xs => (
        // The largest value in a non-empty list.
        ys => 0 < ys.length ? (
            ys.slice(1).reduce(
                (a, y) => y > a ? (
                    y
                ) : a, ys[0]
            )
        ) : undefined
    )(list(xs));


    // readFile :: FilePath -> IO String
    const readFile = fp => {
        // The contents of a text file at the
        // filepath fp.
        const
            e = $(),
            ns = $.NSString
            .stringWithContentsOfFileEncodingError(
                $(fp).stringByStandardizingPath,
                $.NSUTF8StringEncoding,
                e
            );
        return ObjC.unwrap(
            ns.isNil() ? (
                e.localizedDescription
            ) : ns
        );
    };


    // unlines :: [String] -> String
    const unlines = xs =>
        // A single string formed by the intercalation
        // of a list of strings with the newline character.
        xs.join('\n');


    // unwords :: [String] -> String
    const unwords = xs =>
        // A space-separated string derived
        // from a list of words.
        xs.join(' ');


    // zip :: [a] -> [b] -> [(a, b)]
    const zip = xs =>
        // The paired members of xs and ys, up to
        // the length of the shorter of the two lists.
        ys => Array.from({
            length: Math.min(xs.length, ys.length)
        }, (_, i) => Tuple(xs[i])(ys[i]));


    // MAIN ---
    return main();
})();
