(() => {
    "use strict";

    // ----- WORDS USING LARGEST SETS OF CONSONANTS ------

    // uniqueGlyphCounts :: Int -> S.Set Char ->
    // [String] -> [[(String, Int)]]
    const uniqueGlyphCounts = n =>
        // Words of length greater than n, tupled with the
        // size of their subset of used glyphs, and grouped
        // accordingly – sorted by descending set size.
        glyphSet => ws => groupBy(
            on(a => b => a === b)(snd)
        )(
            sortBy(
                flip(comparing(snd))
            )(
                ws.flatMap(
                    w => n < w.length ? [[
                        w,
                        intersection(glyphSet)(
                            new Set([...w])
                        ).size
                    ]] : []
                )
            )
        );


    // noGlyphTwice :: Set Char -> (String, Int) -> Bool
    const noGlyphTwice = glyphs =>
        // True if the number of characters in the string
        // that are included in glyphs matches the
        // precalculated size of the set of glyphs used.
        sn => sn[1] === [...sn[0]]
            .filter(c => glyphs.has(c))
            .length;


    // ---------------------- TEST -----------------------
    // main :: IO ()
    const main = () => {
        const
            upperCs = (
                enumFromToChar("A")("Z")
            ).filter(c => !"AEIOU".includes(c)),
            consonants = new Set(
                [...upperCs, ...upperCs.map(toLower)]
            ),
            noRepetition = noGlyphTwice(consonants);

        return take(1)(
            uniqueGlyphCounts(10)(consonants)(
                readFile("unixdict.txt").split("\n")
            )
        )[0].filter(noRepetition);
    };


    // --------------------- GENERIC ---------------------

    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = a =>
    // A pair of values, possibly of
    // different types.
        b => ({
            type: "Tuple",
            "0": a,
            "1": b,
            length: 2,
            *[Symbol.iterator]() {
                for (const k in this) {
                    if (!isNaN(k)) {
                        yield this[k];
                    }
                }
            }
        });


    // comparing :: Ord a => (b -> a) -> b -> b -> Ordering
    const comparing = f =>
    // The ordering of f(x) and f(y) as a value
    // drawn from {-1, 0, 1}, representing {LT, EQ, GT}.
        x => y => {
            const
                a = f(x),
                b = f(y);

            return a < b ? -1 : (a > b ? 1 : 0);
        };


    // enumFromToChar :: Char -> Char -> [Char]
    const enumFromToChar = m =>
        n => {
            const [intM, intN] = [m, n].map(
                x => x.codePointAt(0)
            );

            return Array.from({
                length: Math.floor(intN - intM) + 1
            }, (_, i) => String.fromCodePoint(intM + i));
        };


    // flip :: (a -> b -> c) -> b -> a -> c
    const flip = op =>
    // The binary function op with
    // its arguments reversed.
        1 !== op.length ? (
            (a, b) => op(b, a)
        ) : (a => b => op(b)(a));


    // groupBy :: (a -> a -> Bool) -> [a] -> [[a]]
    const groupBy = eqOp =>
    // A list of lists, each containing only elements
    // equal under the given equality operator,
    // such that the concatenation of these lists is xs.
        xs => Boolean(xs.length) ? (() => {
            const [h, ...t] = xs;
            const [groups, g] = t.reduce(
                ([gs, a], x) => eqOp(x)(a[0]) ? (
                    Tuple(gs)([...a, x])
                ) : Tuple([...gs, a])([x]),
                Tuple([])([h])
            );

            return [...groups, g];
        })() : [];


    // intersection :: Set -> Set -> Set
    const intersection = a =>
    // The intersection of two sets.
        b => new Set([...a].filter(i => b.has(i)));


    // on :: (b -> b -> c) -> (a -> b) -> a -> a -> c
    const on = f =>
    // e.g. groupBy(on(eq)(length))
        g => a => b => f(g(a))(g(b));


    // readFile :: FilePath -> IO String
    const readFile = fp => {
    // The contents of a text file at the
    // given file path.
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


    // snd :: (a, b) -> b
    const snd = tpl =>
    // Second member of a pair.
        tpl[1];


    // sortBy :: (a -> a -> Ordering) -> [a] -> [a]
    const sortBy = f =>
    // A copy of xs sorted by the comparator function f.
        xs => xs.slice()
            .sort((a, b) => f(a)(b));


    // take :: Int -> [a] -> [a]
    // take :: Int -> String -> String
    const take = n =>
    // The first n elements of a list,
    // string of characters, or stream.
        xs => "GeneratorFunction" !== xs
            .constructor.constructor.name ? (
                xs.slice(0, n)
            ) : Array.from({
                length: n
            }, () => {
                const x = xs.next();

                return x.done ? [] : [x.value];
            }).flat();


    // toLower :: String -> String
    const toLower = s =>
    // Lower-case version of string.
        s.toLocaleLowerCase();


    // MAIN ---
    return JSON.stringify(main());
})();
