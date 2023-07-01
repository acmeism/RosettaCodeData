(() => {
    'use strict';

    // -------------------PASCAL MATRIX--------------------

    // pascalMatrix :: ((Int, Int) -> (Int, Int)) ->
    // Int -> [Int]
    const pascalMatrix = f =>
        n => map(compose(binomialCoefficient, f))(
            range([0, 0], [n - 1, n - 1])
        );

    // binomialCoefficient :: (Int, Int) -> Int
    const binomialCoefficient = nk => {
        const [n, k] = Array.from(nk);
        return enumFromThenTo(k)(
            pred(k)
        )(1).reduceRight((a, x) => quot(
            a * succ(n - x)
        )(x), 1);
    };

    // ------------------------TEST------------------------
    // main :: IO ()
    const main = () => {
        const matrixSize = 5;
        console.log(intercalate('\n\n')(
            zipWith(
                k => xs => k + ':\n' + showMatrix(matrixSize)(xs)
            )(['Lower', 'Upper', 'Symmetric'])(
                apList(
                    map(pascalMatrix)([
                        identity, //              Lower
                        swap, //                  Upper
                        ([a, b]) => [a + b, b] // Symmetric
                    ])
                )([matrixSize])
            )
        ));
    };

    // ----------------------DISPLAY-----------------------

    // showMatrix :: Int -> [Int] -> String
    const showMatrix = n =>
        xs => {
            const
                ks = map(str)(xs),
                w = maximum(map(length)(ks));
            return unlines(
                map(unwords)(chunksOf(n)(
                    map(justifyRight(w)(' '))(ks)
                ))
            );
        };

    // -----------------GENERIC FUNCTIONS------------------

    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = a =>
        b => ({
            type: 'Tuple',
            '0': a,
            '1': b,
            length: 2
        });

    // apList (<*>) :: [(a -> b)] -> [a] -> [b]
    const apList = fs =>
        // The sequential application of each of a list
        // of functions to each of a list of values.
        xs => fs.flatMap(
            f => xs.map(f)
        );

    // chunksOf :: Int -> [a] -> [[a]]
    const chunksOf = n =>
        xs => enumFromThenTo(0)(n)(
            xs.length - 1
        ).reduce(
            (a, i) => a.concat([xs.slice(i, (n + i))]),
            []
        );

    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (...fs) =>
        x => fs.reduceRight((a, f) => f(a), x);

    // concat :: [[a]] -> [a]
    // concat :: [String] -> String
    const concat = xs =>
        0 < xs.length ? (
            xs.every(x => 'string' === typeof x) ? (
                ''
            ) : []
        ).concat(...xs) : xs;

    // cons :: a -> [a] -> [a]
    const cons = x =>
        xs => [x].concat(xs);

    // enumFromThenTo :: Int -> Int -> Int -> [Int]
    const enumFromThenTo = x1 =>
        x2 => y => {
            const d = x2 - x1;
            return Array.from({
                length: Math.floor(y - x2) / d + 2
            }, (_, i) => x1 + (d * i));
        };

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        n => Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);

    // fst :: (a, b) -> a
    const fst = tpl =>
        // First member of a pair.
        tpl[0];

    // identity :: a -> a
    const identity = x =>
        // The identity function. (`id`, in Haskell)
        x;

    // intercalate :: String -> [String] -> String
    const intercalate = s =>
        // The concatenation of xs
        // interspersed with copies of s.
        xs => xs.join(s);

    // justifyRight :: Int -> Char -> String -> String
    const justifyRight = n =>
        // The string s, preceded by enough padding (with
        // the character c) to reach the string length n.
        c => s => n > s.length ? (
            s.padStart(n, c)
        ) : s;

    // length :: [a] -> Int
    const length = xs =>
        // Returns Infinity over objects without finite
        // length. This enables zip and zipWith to choose
        // the shorter argument when one is non-finite,
        // like cycle, repeat etc
        (Array.isArray(xs) || 'string' === typeof xs) ? (
            xs.length
        ) : Infinity;


    // liftA2List :: (a -> b -> c) -> [a] -> [b] -> [c]
    const liftA2List = f => xs => ys =>
        // The binary operator f lifted to a function over two
        // lists. f applied to each pair of arguments in the
        // cartesian product of xs and ys.
        xs.flatMap(
            x => ys.map(f(x))
        );

    // map :: (a -> b) -> [a] -> [b]
    const map = f =>
        // The list obtained by applying f to each element of xs.
        // (The image of xs under f).
        xs => (Array.isArray(xs) ? (
            xs
        ) : xs.split('')).map(f);

    // maximum :: Ord a => [a] -> a
    const maximum = xs =>
        // The largest value in a non-empty list.
        0 < xs.length ? (
            xs.slice(1).reduce(
                (a, x) => x > a ? (
                    x
                ) : a, xs[0]
            )
        ) : undefined;

    // pred :: Enum a => a -> a
    const pred = x =>
        x - 1;

    // quot :: Int -> Int -> Int
    const quot = n => m => Math.floor(n / m);

    // The list of values in the subrange defined by a bounding pair.

    // range([0, 2]) -> [0,1,2]
    // range([[0,0], [2,2]])
    //  -> [[0,0],[0,1],[0,2],[1,0],[1,1],[1,2],[2,0],[2,1],[2,2]]
    // range([[0,0,0],[1,1,1]])
    //  -> [[0,0,0],[0,0,1],[0,1,0],[0,1,1],[1,0,0],[1,0,1],[1,1,0],[1,1,1]]

    // range :: Ix a => (a, a) -> [a]
    function range() {
        const
            args = Array.from(arguments),
            ab = 1 !== args.length ? (
                args
            ) : args[0],
            [as, bs] = [ab[0], ab[1]].map(
                x => Array.isArray(x) ? (
                    x
                ) : (undefined !== x.type) &&
                (x.type.startsWith('Tuple')) ? (
                    Array.from(x)
                ) : [x]
            ),
            an = as.length;
        return (an === bs.length) ? (
            1 < an ? (
                traverseList(x => x)(
                    as.map((_, i) => enumFromTo(as[i])(bs[i]))
                )
            ) : enumFromTo(as[0])(bs[0])
        ) : [];
    };

    // snd :: (a, b) -> b
    const snd = tpl => tpl[1];

    // str :: a -> String
    const str = x => x.toString();

    // succ :: Enum a => a -> a
    const succ = x =>
        1 + x;

    // swap :: (a, b) -> (b, a)
    const swap = ab =>
        // The pair ab with its order reversed.
        Tuple(ab[1])(
            ab[0]
        );

    // take :: Int -> [a] -> [a]
    // take :: Int -> String -> String
    const take = n =>
        // The first n elements of a list,
        // string of characters, or stream.
        xs => xs.slice(0, n);

    // traverseList :: (Applicative f) => (a -> f b) -> [a] -> f [b]
    const traverseList = f =>
        // Collected results of mapping each element
        // of a structure to an action, and evaluating
        // these actions from left to right.
        xs => 0 < xs.length ? (() => {
            const
                vLast = f(xs.slice(-1)[0]),
                t = vLast.type || 'List';
            return xs.slice(0, -1).reduceRight(
                (ys, x) => liftA2List(cons)(f(x))(ys),
                liftA2List(cons)(vLast)([
                    []
                ])
            );
        })() : [
            []
        ];

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

    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = f =>
        // A list constructed by zipping with a
        // custom function, rather than with the
        // default tuple constructor.
        xs => ys => {
            const
                lng = Math.min(length(xs), length(ys)),
                vs = take(lng)(ys);
            return take(lng)(xs)
                .map((x, i) => f(x)(vs[i]));
        };

    // MAIN ---
    return main();
})();
