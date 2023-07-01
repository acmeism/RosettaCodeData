(() => {
    // n-ary Cartesian product of a list of lists
    // ( Imperative implementation )

    // cartProd :: [a] -> [b] -> [[a, b]]
    const cartProd = lists => {
        let ps = [],
            acc = [
                []
            ],
            i = lists.length;
        while (i--) {
            let subList = lists[i],
                j = subList.length;
            while (j--) {
                let x = subList[j],
                    k = acc.length;
                while (k--) ps.push([x].concat(acc[k]))
            };
            acc = ps;
            ps = [];
        };
        return acc.reverse();
    };

    // GENERIC FUNCTIONS ------------------------------------------------------

    // intercalate :: String -> [a] -> String
    const intercalate = (s, xs) => xs.join(s);

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f);

    // show :: a -> String
    const show = x => JSON.stringify(x);

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // TEST -------------------------------------------------------------------
    return intercalate('\n\n', [show(cartProd([
            [1, 2],
            [3, 4]
        ])),
        show(cartProd([
            [3, 4],
            [1, 2]
        ])),
        show(cartProd([
            [1, 2],
            []
        ])),
        show(cartProd([
            [],
            [1, 2]
        ])),
        unlines(map(show, cartProd([
            [1776, 1789],
            [7, 12],
            [4, 14, 23],
            [0, 1]
        ]))),
        show(cartProd([
            [1, 2, 3],
            [30],
            [50, 100]
        ])),
        show(cartProd([
            [1, 2, 3],
            [],
            [50, 100]
        ]))
    ]);
})();
