(() => {
    'use strict';

    // --------- KRONECKER PRODUCT OF TWO MATRICES ---------

    // kprod :: [[Num]] -> [[Num]] -> [[Num]]
    const kprod = xs =>
        ys => concatMap(
            compose(map(concat), transpose)
        )(
            map(map(
                flip(compose(map, map, mul))(ys)
            ))(xs)
        );

    // ----------------------- TEST ------------------------
    // main :: IO ()
    const main = () =>
        unlines(map(compose(unlines, map(show)))([
            kprod([
                [1, 2],
                [3, 4]
            ])([
                [0, 5],
                [6, 7]
            ]), [], // One empty output line
            kprod([
                [0, 1, 0],
                [1, 1, 1],
                [0, 1, 0]
            ])([
                [1, 1, 1, 1],
                [1, 0, 0, 1],
                [1, 1, 1, 1]
            ])
        ]));


    // ----------------- GENERIC FUNCTIONS -----------------

    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (...fs) =>
        x => fs.reduceRight((a, f) => f(a), x);


    // concat :: [[a]] -> [a]
    const concat = xs => [].concat.apply([], xs);


    // concatMap :: (a -> [b]) -> [a] -> [b]
    const concatMap = f =>
        xs => xs.flatMap(f);


    // flip :: (a -> b -> c) -> b -> a -> c
    const flip = f =>
        x => y => f(y)(x);


    // map :: (a -> b) -> [a] -> [b]
    const map = f =>
        xs => xs.map(f);


    // mul (*) :: Num a => a -> a -> a
    const mul = a =>
        b => a * b;


    // show :: a -> String
    const show = x =>
        JSON.stringify(x); //, null, 2);


    // transpose :: [[a]] -> [[a]]
    const transpose = xs =>
        xs[0].map((_, col) => xs.map(row => row[col]));


    // unlines :: [String] -> String
    const unlines = xs =>
        xs.join('\n');


    // MAIN ---
    console.log(main());
})();
