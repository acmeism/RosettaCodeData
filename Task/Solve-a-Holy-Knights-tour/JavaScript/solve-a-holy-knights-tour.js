(() => {
    'use strict';

    // problems :: [[String]]
    const problems = [
        [
              " 000    " //
            , " 0 00   " //
            , " 0000000" //
            , "000  0 0" //
            , "0 0  000" //
            , "1000000 " //
            , "  00 0  " //
            , "   000  " //
        ],
        [
              "-----1-0-----" //
            , "-----0-0-----" //
            , "----00000----" //
            , "-----000-----" //
            , "--0--0-0--0--" //
            , "00000---00000" //
            , "--00-----00--" //
            , "00000---00000" //
            , "--0--0-0--0--" //
            , "-----000-----" //
            , "----00000----" //
            , "-----0-0-----" //
            , "-----0-0-----" //
        ]
    ];

    // GENERIC FUNCTIONS ------------------------------------------------------

    // comparing :: (a -> b) -> (a -> a -> Ordering)
    const comparing = f =>
        (x, y) => {
            const
                a = f(x),
                b = f(y);
            return a < b ? -1 : a > b ? 1 : 0
        };

    // concat :: [[a]] -> [a] | [String] -> String
    const concat = xs =>
        xs.length > 0 ? (() => {
            const unit = typeof xs[0] === 'string' ? '' : [];
            return unit.concat.apply(unit, xs);
        })() : [];

    // charColRow :: Char -> [String] -> Maybe (Int, Int)
    const charColRow = (c, rows) =>
        foldr((a, xs, iRow) =>
            a.nothing ? (() => {
                const mbiCol = elemIndex(c, xs);
                return mbiCol.nothing ? mbiCol : {
                    just: [mbiCol.just, iRow],
                    nothing: false
                };
            })() : a, {
                nothing: true
            }, rows);

    // 2 or more arguments
    // curry :: Function -> Function
    const curry = (f, ...args) => {
        const go = xs => xs.length >= f.length ? (f.apply(null, xs)) :
            function () {
                return go(xs.concat(Array.from(arguments)));
            };
        return go([].slice.call(args, 1));
    };

    // elem :: Eq a => a -> [a] -> Bool
    const elem = (x, xs) => xs.indexOf(x) !== -1;

    // elemIndex :: Eq a => a -> [a] -> Maybe Int
    const elemIndex = (x, xs) => {
        const i = xs.indexOf(x);
        return {
            nothing: i === -1,
            just: i
        };
    };

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = (m, n) =>
        Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i);

    // filter :: (a -> Bool) -> [a] -> [a]
    const filter = (f, xs) => xs.filter(f);

    // findIndex :: (a -> Bool) -> [a] -> Maybe Int
    const findIndex = (f, xs) => {
        for (var i = 0, lng = xs.length; i < lng; i++) {
            if (f(xs[i])) return {
                nothing: false,
                just: i
            };
        }
        return {
            nothing: true
        };
    };

    // foldl :: (b -> a -> b) -> b -> [a] -> b
    const foldl = (f, a, xs) => xs.reduce(f, a);

    // foldr (a -> b -> b) -> b -> [a] -> b
    const foldr = (f, a, xs) => xs.reduceRight(f, a);

    // groupBy :: (a -> a -> Bool) -> [a] -> [[a]]
    const groupBy = (f, xs) => {
        const dct = xs.slice(1)
            .reduce((a, x) => {
                const
                    h = a.active.length > 0 ? a.active[0] : undefined,
                    blnGroup = h !== undefined && f(h, x);
                return {
                    active: blnGroup ? a.active.concat([x]) : [x],
                    sofar: blnGroup ? a.sofar : a.sofar.concat([a.active])
                };
            }, {
                active: xs.length > 0 ? [xs[0]] : [],
                sofar: []
            });
        return dct.sofar.concat(dct.active.length > 0 ? [dct.active] : []);
    };

    // intercalate :: String -> [a] -> String
    const intercalate = (s, xs) => xs.join(s);

    // intersectBy::(a - > a - > Bool) - > [a] - > [a] - > [a]
    const intersectBy = (eq, xs, ys) =>
        (xs.length > 0 && ys.length > 0) ?
        xs.filter(x => ys.some(curry(eq)(x))) : [];

    // justifyRight :: Int -> Char -> Text -> Text
    const justifyRight = (n, cFiller, strText) =>
        n > strText.length ? (
            (cFiller.repeat(n) + strText)
            .slice(-n)
        ) : strText;

    // length :: [a] -> Int
    const length = xs => xs.length;

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f);

    // mappendComparing :: [(a -> b)] -> (a -> a -> Ordering)
    const mappendComparing = fs => (x, y) =>
        fs.reduce((ord, f) => {
            if (ord !== 0) return ord;
            const
                a = f(x),
                b = f(y);
            return a < b ? -1 : a > b ? 1 : 0
        }, 0);

    // maximumBy :: (a -> a -> Ordering) -> [a] -> a
    const maximumBy = (f, xs) =>
        xs.reduce((a, x) => a === undefined ? x : (
            f(x, a) > 0 ? x : a
        ), undefined);

    // min :: Ord a => a -> a -> a
    const min = (a, b) => b < a ? b : a;

    // replicate :: Int -> a -> [a]
    const replicate = (n, a) => {
        let v = [a],
            o = [];
        if (n < 1) return o;
        while (n > 1) {
            if (n & 1) o = o.concat(v);
            n >>= 1;
            v = v.concat(v);
        }
        return o.concat(v);
    };

    // sortBy :: (a -> a -> Ordering) -> [a] -> [a]
    const sortBy = (f, xs) => xs.slice()
        .sort(f);

    // splitOn :: String -> String -> [String]
    const splitOn = (s, xs) => xs.split(s);

    // take :: Int -> [a] -> [a]
    const take = (n, xs) => xs.slice(0, n);

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // until :: (a -> Bool) -> (a -> a) -> a -> a
    const until = (p, f, x) => {
        let v = x;
        while (!p(v)) v = f(v);
        return v;
    };

    // zip :: [a] -> [b] -> [(a,b)]
    const zip = (xs, ys) =>
        xs.slice(0, Math.min(xs.length, ys.length))
        .map((x, i) => [x, ys[i]]);

    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = (f, xs, ys) =>
        Array.from({
            length: min(xs.length, ys.length)
        }, (_, i) => f(xs[i], ys[i]));

    // HOLY KNIGHT's TOUR FUNCTIONS -------------------------------------------

    // kmoves :: (Int, Int) -> [(Int, Int)]
    const kmoves = ([x, y]) => map(
        ([a, b]) => [a + x, b + y], [
            [1, 2],
            [1, -2],
            [-1, 2],
            [-1, -2],
            [2, 1],
            [2, -1],
            [-2, 1],
            [-2, -1]
        ]);

    // rowPosns :: Int -> String -> [(Int, Int)]
    const rowPosns = (iRow, s) => {
        return foldl((a, x, i) => (elem(x, ['0', '1']) ? (
            a.concat([
                [i, iRow]
            ])
        ) : a), [], splitOn('', s));
    };

    // hash :: (Int, Int) -> String
    const hash = ([col, row]) => col.toString() + '.' + row.toString();

    // Start node, and degree-sorted cache of moves from each node
    // All node references are hash strings (for this cache)

    // problemModel :: [[String]] -> {cache: {nodeKey: [nodeKey], start:String}}
    const problemModel = boardLines => {
        const
            steps = foldl((a, xs, i) =>
                a.concat(rowPosns(i, xs)), [], boardLines),
            courseMoves = (xs, [x, y]) => intersectBy(
                ([a, b], [c, d]) => a === c && b === d, kmoves([x, y]), xs
            ),
            maybeStart = charColRow('1', boardLines);
        return {
            start: maybeStart.nothing ? '' : hash(maybeStart.just),
            boardWidth: boardLines.length > 0 ? boardLines[0].length : 0,
            stepCount: steps.length,
            cache: (() => {
                const moveCache = foldl((a, xy) => (
                        a[hash(xy)] = map(hash, courseMoves(steps, xy)),
                        a
                    ), {}, steps),
                    lstMoves = Object.keys(moveCache),
                    dctDegree = foldl((a, k) =>
                        (a[k] = moveCache[k].length,
                            a), {}, lstMoves);

                return foldl((a, k) => (
                    a[k] = sortBy(comparing(x => dctDegree[x]), moveCache[k]),
                    a
                ), {}, lstMoves);
            })()
        };
    };

    // firstSolution :: {nodeKey: [nodeKey]} -> Int ->
    //      nodeKey -> nodeKey -> [nodeKey] ->
    //      -> {path::[nodeKey], pathLen::Int, found::Bool}
    const firstSolution = (dctMoves, intTarget, strStart, strNodeKey, path) => {
        const
            intPath = path.length,
            moves = dctMoves[strNodeKey];

        if ((intTarget - intPath) < 2 && elem(strStart, moves)) {
            return {
                nothing: false,
                just: [strStart, strNodeKey].concat(path),
                pathLen: intTarget
            };
        }

        const
            nexts = filter(k => !elem(k, path), moves),
            intNexts = nexts.length,
            lstFullPath = [strNodeKey].concat(path);

        // Until we find a full path back to start
        return until(
            x => (x.nothing === false || x.i >= intNexts),
            x => {
                const
                    idx = x.i,
                    dctSoln = firstSolution(
                        dctMoves, intTarget, strStart, nexts[idx], lstFullPath
                    );
                return {
                    i: idx + 1,
                    nothing: dctSoln.nothing,
                    just: dctSoln.just,
                    pathLen: dctSoln.pathLen
                };
            }, {
                nothing: true,
                just: [],
                i: 0
            }
        );
    };

    // maybeTour :: [String] -> {
    //    nothing::Bool, Just::[nodeHash], i::Int: pathLen::Int }
    const maybeTour = trackLines => {
        const
            dctModel = problemModel(trackLines),
            strStart = dctModel.start;
        return strStart !== '' ? firstSolution(
            dctModel.cache, dctModel.stepCount, strStart, strStart, []
        ) : {
            nothing: true
        };
    };

    // showLine :: Int -> Int -> String -> Maybe (Int, Int) ->
    //              [(Int, Int, String)] -> String
    const showLine = curry((intCell, strFiller, maybeStart, xs) => {
        const
            blnSoln = maybeStart.nothing,
            [startCol, startRow] = blnSoln ? [0, 0] : maybeStart.just;
        return foldl((a, [iCol, iRow, sVal], i, xs) => ({
                    col: iCol + 1,
                    txt: a.txt +
                        concat(replicate((iCol - a.col) * intCell, strFiller)) +
                        justifyRight(
                            intCell, strFiller,
                            (blnSoln ? sVal : (
                                iRow === startRow &&
                                iCol === startCol ? '1' : '0')
                            )
                        )
                }), {
                    col: 0,
                    txt: ''
                },
                xs
            )
            .txt
    });

    // solutionString :: [String] -> Int -> String
    const solutionString = (boardLines, iProblem) => {
        const
            dtePre = Date.now(),
            intCols = boardLines.length > 0 ? boardLines[0].length : 0,
            soln = maybeTour(boardLines),
            intMSeconds = Date.now() - dtePre;

        if (soln.nothing) return 'No solution found …';

        const
            kCol = 0,
            kRow = 1,
            kSeq = 2,
            steps = soln.just,
            lstTriples = zipWith((h, n) => {
                    const [col, row] = map(
                        x => parseInt(x, 10), splitOn('.', h)
                    );
                    return [col, row, n.toString()];
                },
                steps,
                enumFromTo(1, soln.pathLen)),
            cellWidth = length(maximumBy(
                comparing(x => length(x[kSeq])), lstTriples
            )[kSeq]) + 1,
            lstGroups = groupBy(
                (a, b) => a[kRow] === b[kRow],
                sortBy(
                    mappendComparing([x => x[kRow], x => x[kCol]]),
                    lstTriples
                )),
            startXY = take(2, lstTriples[0]),
            strMap = 'PROBLEM ' + (parseInt(iProblem, 10) + 1) + '.\n\n' +
            unlines(map(showLine(cellWidth, ' ', {
                nothing: false,
                just: startXY
            }), lstGroups)),
            strSoln = 'First solution found in c. ' +
            intMSeconds + ' milliseconds:\n\n' +
            unlines(map(showLine(cellWidth, ' ', {
                nothing: true,
                just: startXY
            }), lstGroups)) + '\n\n';

        console.log(strSoln);
        return strMap + '\n\n' + strSoln;
    };

    // TEST -------------------------------------------------------------------
    return unlines(map(solutionString, problems));
})();
