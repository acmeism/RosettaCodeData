(() => {
    const main = () => {
        // n-ary Cartesian product of a list of lists.

        // cartProdN :: [[a]] -> [[a]]
        const cartProdN = foldr(
            xs => as =>
            bind(as)(
                x => bind(xs)(
                    a => [
                        [a].concat(x)
                    ]
                )
            )
        )([
            []
        ]);

        // TEST -------------------------------------------
        return intercalate('\n\n')([
            map(show)(
                cartProdN([
                    [1776, 1789],
                    [7, 12],
                    [4, 14, 23],
                    [0, 1]
                ])
            ).join('\n'),
            show(cartProdN([
                [1, 2, 3],
                [30],
                [50, 100]
            ])),
            show(cartProdN([
                [1, 2, 3],
                [],
                [50, 100]
            ]))
        ])
    };

    // GENERIC FUNCTIONS ----------------------------------

    // bind ::  [a] -> (a -> [b]) -> [b]
    const bind = xs => f => xs.flatMap(f);

    // foldr :: (a -> b -> b) -> b -> [a] -> b
    const foldr = f => a => xs =>
        xs.reduceRight((a, x) => f(x)(a), a);

    // intercalate :: String -> [a] -> String
    const intercalate = s => xs => xs.join(s);

    // map :: (a -> b) -> [a] -> [b]
    const map = f => xs => xs.map(f);

    // show :: a -> String
    const show = x => JSON.stringify(x);

    return main();
})();
