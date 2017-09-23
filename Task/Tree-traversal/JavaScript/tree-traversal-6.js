(() => {
    // TRAVERSALS -------------------------------------------------------------

    // preorder Tree a -> [a]
    const preorder = a => [a[v]]
        .concat(a[l] ? preorder(a[l]) : [])
        .concat(a[r] ? preorder(a[r]) : []);

    // inorder Tree a -> [a]
    const inorder = a =>
        (a[l] ? inorder(a[l]) : [])
        .concat(a[v])
        .concat(a[r] ? inorder(a[r]) : []);

    // postorder Tree a -> [a]
    const postorder = a =>
        (a[l] ? postorder(a[l]) : [])
        .concat(a[r] ? postorder(a[r]) : [])
        .concat(a[v]);

    // levelorder Tree a -> [a]
    const levelorder = a => (function go(x) {
        return x.length ? (
            x[0] ? (
                [x[0][v]].concat(
                    go(x.slice(1)
                        .concat([x[0][l], x[0][r]])
                    )
                )
            ) : go(x.slice(1))
        ) : [];
    })([a]);


    // GENERIC FUNCTIONS  -----------------------------------------------------

    // A list of functions applied to a list of arguments
    // <*> :: [(a -> b)] -> [a] -> [b]
    const ap = (fs, xs) => //
        [].concat.apply([], fs.map(f => //
            [].concat.apply([], xs.map(x => [f(x)]))));

    // intercalate :: String -> [a] -> String
    const intercalate = (s, xs) => xs.join(s);

    // justifyLeft :: Int -> Char -> Text -> Text
    const justifyLeft = (n, cFiller, strText) =>
        n > strText.length ? (
            (strText + cFiller.repeat(n))
            .substr(0, n)
        ) : strText;

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // unwords :: [String] -> String
    const unwords = xs => xs.join(' ');

    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = (f, xs, ys) =>
        Array.from({
            length: Math.min(xs.length, ys.length)
        }, (_, i) => f(xs[i], ys[i]));

    // TEST -------------------------------------------------------------------
    // asciiTree :: String
    const asciiTree = unlines([
        '         1',
        '        / \\',
        '       /   \\',
        '      /     \\',
        '     2       3',
        '    / \\     /',
        '   4   5   6',
        '  /       / \\',
        ' 7       8   9'
    ]);

    const [v, l, r] = [0, 1, 2],
    tree = [1, [2, [4, [7]],
                [5]
            ],
            [3, [6, [8],
                [9]
            ]]
        ],

        // fs :: [(Tree a -> [a])]
        fs = [preorder, inorder, postorder, levelorder];

    return asciiTree + '\n\n' +
        intercalate('\n',
            zipWith(
                (f, xs) => justifyLeft(12, ' ', f.name + ':') + unwords(xs),
                fs,
                ap(fs, [tree])
            )
        );
})();
