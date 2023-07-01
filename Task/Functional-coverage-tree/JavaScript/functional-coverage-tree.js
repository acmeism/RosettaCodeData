(() => {
    'use strict';

    // updatedCoverageOutline :: String -> String
    const updatedCoverageOutline = outlineText => {
        const
            delimiter = '|',
            indentedLines = indentLevelsFromLines(lines(outlineText)),
            columns = init(tokenizeWith(delimiter)(snd(indentedLines[0])));

        // SERIALISATION OF UPDATED PARSE TREE (TO NEW OUTLINE TEXT)
        return tabulation(delimiter)(
            columns.concat('SHARE OF RESIDUE\n')
        ) + unlines(
            indentedLinesFromTree(
                showCoverage(delimiter))('    ')(

                // TWO TRAVERSAL COMPUTATIONS

                withResidueShares(1.0)(
                    foldTree(weightedCoverage)(

                        // PARSE TREE (FROM OUTLINE TEXT)
                        fmapTree(compose(
                            partialRecord, tokenizeWith(delimiter)
                        ))(fst(
                            forestFromLineIndents(tail(indentedLines))
                        ))
                    )
                ))
        );
    };

    // TEST -----------------------------------------------
    // main :: IO ()
    const main = () =>
        console.log(
            // strOutline is included as literal text
            // at the foot of this code listing.
            updatedCoverageOutline(strOutline)
        );

    // COVERAGE AND SHARES OF RESIDUE ---------------------

    // weightedCoverage :: Dict -> Forest Dict -> Tree Dict
    const weightedCoverage = x => xs => {
        const
            cws = map(compose(
                fanArrow(x => x.coverage)(x => x.weight),
                root
            ))(xs),
            totalWeight = cws.reduce((a, tpl) => a + snd(tpl), 0);
        return Node(
            insertDict('coverage')(
                cws.reduce((a, tpl) => {
                    const [c, w] = Array.from(tpl);
                    return a + (c * w);
                }, x.coverage) / (
                    0 < totalWeight ? totalWeight : 1
                )
            )(x)
        )(xs);
    };


    // withResidueShares :: Float -> Tree Dict -> Tree Dict
    const withResidueShares = shareOfTotal => tree => {
        const go = fraction => node => {
            const
                nodeRoot = node.root,
                forest = node.nest,
                weights = forest.map(x => x.root.weight),
                weightTotal = sum(weights);
            return Node(
                insertDict('share')(
                    fraction * (1 - nodeRoot.coverage)
                )(nodeRoot)
            )(
                zipWith(go)(
                    weights.map(w => fraction * (w / weightTotal))
                )(forest)
            );
        };
        return go(shareOfTotal)(tree);
    };


    // OUTLINE PARSED TO TREE -----------------------------

    // forestFromLineIndents :: [(Int, String)] -> [Tree String]
    const forestFromLineIndents = tuples => {
        const go = xs =>
            0 < xs.length ? (() => {
                const [n, s] = Array.from(xs[0]);
                // Lines indented under this line,
                // tupled with all the rest.
                const [firstTreeLines, rest] = Array.from(
                    span(x => n < x[0])(xs.slice(1))
                );
                // This first tree, and then the rest.
                return [Node(s)(go(firstTreeLines))]
                    .concat(go(rest));
            })() : [];
        return go(tuples);
    };

    // indentLevelsFromLines :: [String] -> [(Int, String)]
    const indentLevelsFromLines = xs => {
        const
            indentTextPairs = xs.map(compose(
                firstArrow(length), span(isSpace)
            )),
            indentUnit = minimum(indentTextPairs.flatMap(pair => {
                const w = fst(pair);
                return 0 < w ? [w] : [];
            }));
        return indentTextPairs.map(
            firstArrow(flip(div)(indentUnit))
        );
    };

    // partialRecord :: [String] -> Dict
    const partialRecord = xs => {
        const [name, weightText, coverageText] = take(3)(
            xs.concat(['', '', ''])
        );
        return {
            name: name || '?',
            weight: parseFloat(weightText) || 1.0,
            coverage: parseFloat(coverageText) || 0.0,
            share: 0.0
        };
    };

    // tokenizeWith :: String -> String -> [String]
    const tokenizeWith = delimiter =>
        // A sequence of trimmed tokens obtained by
        // splitting s on the supplied delimiter.
        s => s.split(delimiter).map(x => x.trim());


    // TREE SERIALIZED TO OUTLINE -------------------------

    // indentedLinesFromTree :: (String -> a -> String) ->
    // String -> Tree a -> [String]
    const indentedLinesFromTree = showRoot =>
        strTab => tree => {
            const go = indent =>
                node => [showRoot(indent)(node.root)]
                .concat(node.nest.flatMap(go(strTab + indent)));
            return go('')(tree);
        };

    // showN :: Int -> Float -> String
    const showN = p =>
        n => justifyRight(7)(' ')(n.toFixed(p));

    // showCoverage :: String -> String -> Dict -> String
    const showCoverage = delimiter =>
        indent => x => tabulation(delimiter)(
            [indent + x.name, showN(0)(x.weight)]
            .concat([x.coverage, x.share].map(showN(4)))
        );

    // tabulation :: String -> [String] -> String
    const tabulation = delimiter =>
        // Up to 4 tokens drawn from the argument list,
        // as a single string with fixed left-justified
        // white-space widths, between delimiters.
        compose(
            intercalate(delimiter + ' '),
            zipWith(flip(justifyLeft)(' '))([31, 9, 9, 9])
        );


    // GENERIC AND REUSABLE FUNCTIONS ---------------------

    // Node :: a -> [Tree a] -> Tree a
    const Node = v => xs => ({
        type: 'Node',
        root: v, // any type of value (consistent across tree)
        nest: xs || []
    });

    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = a => b => ({
        type: 'Tuple',
        '0': a,
        '1': b,
        length: 2
    });

    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (...fs) =>
        x => fs.reduceRight((a, f) => f(a), x);

    // concat :: [[a]] -> [a]
    // concat :: [String] -> String
    const concat = xs =>
        0 < xs.length ? (() => {
            const unit = 'string' !== typeof xs[0] ? (
                []
            ) : '';
            return unit.concat.apply(unit, xs);
        })() : [];

    // div :: Int -> Int -> Int
    const div = x => y => Math.floor(x / y);

    // either :: (a -> c) -> (b -> c) -> Either a b -> c
    const either = fl => fr => e =>
        'Either' === e.type ? (
            undefined !== e.Left ? (
                fl(e.Left)
            ) : fr(e.Right)
        ) : undefined;

    // Compose a function from a simple value to a tuple of
    // the separate outputs of two different functions

    // fanArrow (&&&) :: (a -> b) -> (a -> c) -> (a -> (b, c))
    const fanArrow = f => g => x => Tuple(f(x))(
        g(x)
    );

    // Lift a simple function to one which applies to a tuple,
    // transforming only the first item of the tuple

    // firstArrow :: (a -> b) -> ((a, c) -> (b, c))
    const firstArrow = f => xy => Tuple(f(xy[0]))(
        xy[1]
    );

    // flip :: (a -> b -> c) -> b -> a -> c
    const flip = f =>
        1 < f.length ? (
            (a, b) => f(b, a)
        ) : (x => y => f(y)(x));

    // fmapTree :: (a -> b) -> Tree a -> Tree b
    const fmapTree = f => tree => {
        const go = node => Node(f(node.root))(
            node.nest.map(go)
        );
        return go(tree);
    };

    // foldTree :: (a -> [b] -> b) -> Tree a -> b
    const foldTree = f => tree => {
        const go = node => f(node.root)(
            node.nest.map(go)
        );
        return go(tree);
    };

    // foldl1 :: (a -> a -> a) -> [a] -> a
    const foldl1 = f => xs =>
        1 < xs.length ? xs.slice(1)
        .reduce(uncurry(f), xs[0]) : xs[0];

    // fst :: (a, b) -> a
    const fst = tpl => tpl[0];

    // init :: [a] -> [a]
    const init = xs =>
        0 < xs.length ? (
            xs.slice(0, -1)
        ) : undefined;

    // insertDict :: String -> a -> Dict -> Dict
    const insertDict = k => v => dct =>
        Object.assign({}, dct, {
            [k]: v
        });

    // intercalate :: [a] -> [[a]] -> [a]
    // intercalate :: String -> [String] -> String
    const intercalate = sep =>
        xs => xs.join(sep);

    // isSpace :: Char -> Bool
    const isSpace = c => /\s/.test(c);

    // justifyLeft :: Int -> Char -> String -> String
    const justifyLeft = n => cFiller => s =>
        n > s.length ? (
            s.padEnd(n, cFiller)
        ) : s;

    // justifyRight :: Int -> Char -> String -> String
    const justifyRight = n => cFiller => s =>
        n > s.length ? (
            s.padStart(n, cFiller)
        ) : s;

    // length :: [a] -> Int
    const length = xs =>
        (Array.isArray(xs) || 'string' === typeof xs) ? (
            xs.length
        ) : Infinity;

    // lines :: String -> [String]
    const lines = s => s.split(/[\r\n]/);

    // map :: (a -> b) -> [a] -> [b]
    const map = f => xs =>
        (Array.isArray(xs) ? (
            xs
        ) : xs.split('')).map(f);

    // minimum :: Ord a => [a] -> a
    const minimum = xs =>
        0 < xs.length ? (
            foldl1(a => x => x < a ? x : a)(xs)
        ) : undefined;

    // root :: Tree a -> a
    const root = tree => tree.root;

    // showLog :: a -> IO ()
    const showLog = (...args) =>
        console.log(
            args
            .map(JSON.stringify)
            .join(' -> ')
        );

    // snd :: (a, b) -> b
    const snd = tpl => tpl[1];

    // span :: (a -> Bool) -> [a] -> ([a], [a])
    const span = p => xs => {
        const iLast = xs.length - 1;
        return splitAt(
            until(i => iLast < i || !p(xs[i]))(
                succ
            )(0)
        )(xs);
    };

    // splitAt :: Int -> [a] -> ([a], [a])
    const splitAt = n => xs =>
        Tuple(xs.slice(0, n))(
            xs.slice(n)
        );

    // succ :: Enum a => a -> a
    const succ = x =>
        1 + x;

    // sum :: [Num] -> Num
    const sum = xs =>
        xs.reduce((a, x) => a + x, 0);

    // tail :: [a] -> [a]
    const tail = xs =>
        0 < xs.length ? xs.slice(1) : [];

    // take :: Int -> [a] -> [a]
    // take :: Int -> String -> String
    const take = n => xs =>
        'GeneratorFunction' !== xs.constructor.constructor.name ? (
            xs.slice(0, n)
        ) : [].concat.apply([], Array.from({
            length: n
        }, () => {
            const x = xs.next();
            return x.done ? [] : [x.value];
        }));

    // uncurry :: (a -> b -> c) -> ((a, b) -> c)
    const uncurry = f =>
        (x, y) => f(x)(y);

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // until :: (a -> Bool) -> (a -> a) -> a -> a
    const until = p => f => x => {
        let v = x;
        while (!p(v)) v = f(v);
        return v;
    };

    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = f => xs => ys =>
        xs.slice(
            0, Math.min(xs.length, ys.length)
        ).map((x, i) => f(x)(ys[i]));

    // SOURCE OUTLINE -----------------------------------------

    const strOutline = `NAME_HIERARCHY                  |WEIGHT  |COVERAGE  |
cleaning                        |        |          |
    house1                      |40      |          |
        bedrooms                |        |0.25      |
        bathrooms               |        |          |
            bathroom1           |        |0.5       |
            bathroom2           |        |          |
            outside_lavatory    |        |1         |
        attic                   |        |0.75      |
        kitchen                 |        |0.1       |
        living_rooms            |        |          |
            lounge              |        |          |
            dining_room         |        |          |
            conservatory        |        |          |
            playroom            |        |1         |
        basement                |        |          |
        garage                  |        |          |
        garden                  |        |0.8       |
    house2                      |60      |          |
        upstairs                |        |          |
            bedrooms            |        |          |
                suite_1         |        |          |
                suite_2         |        |          |
                bedroom_3       |        |          |
                bedroom_4       |        |          |
            bathroom            |        |          |
            toilet              |        |          |
            attics              |        |0.6       |
        groundfloor             |        |          |
            kitchen             |        |          |
            living_rooms        |        |          |
                lounge          |        |          |
                dining_room     |        |          |
                conservatory    |        |          |
                playroom        |        |          |
            wet_room_&_toilet   |        |          |
            garage              |        |          |
            garden              |        |0.9       |
            hot_tub_suite       |        |1         |
        basement                |        |          |
            cellars             |        |1         |
            wine_cellar         |        |1         |
            cinema              |        |0.75      |`;

    // MAIN ---
    return main();
})();
