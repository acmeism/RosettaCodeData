(() => {
    'use strict';

    // drawTree :: Bool -> Tree String -> String
    const drawTree = blnCompact => tree => {
        // Simple decorated-outline style of ascii tree drawing,
        // with nodeless lines pruned out if blnCompact is True.
        const xs = draw(tree);
        return unlines(
            blnCompact ? (
                xs.filter(
                    s => s.split('')
                    .some(c => !' │'.includes(c))
                )
            ) : xs
        );
    };

    // draw :: Tree String -> [String]
    const draw = node => {
        // shift :: String -> String -> [String] -> [String]
        const shift = (first, other, xs) =>
            zipWith(
                append,
                cons(first, replicate(xs.length - 1, other)),
                xs
            );
        // drawSubTrees :: [Tree String] -> [String]
        const drawSubTrees = xs => {
            const lng = xs.length;
            return 0 < lng ? (
                1 < lng ? append(
                    cons(
                        '│',
                        shift('├─ ', '│  ', draw(xs[0]))
                    ),
                    drawSubTrees(xs.slice(1))
                ) : cons('│', shift('└─ ', '   ', draw(xs[0])))
            ) : [];
        };
        return append(
            lines(node.root.toString()),
            drawSubTrees(node.nest)
        );
    };

    // TEST -----------------------------------------------
    const main = () => {
        const tree = Node(
            'Alpha', [
                Node('Beta', [
                    Node('Epsilon', []),
                    Node('Zeta', []),
                    Node('Eta', [])
                ]),
                Node('Gamma', [Node('Theta', [])]),
                Node('Delta', [
                    Node('Iota', []),
                    Node('Kappa', []),
                    Node('Lambda', [])
                ])
            ]);

        return [true, false]
        .map(blnCompact => drawTree(blnCompact)(tree))
        .join('\n\n');
    };

    // GENERIC FUNCTIONS ----------------------------------

    // Node :: a -> [Tree a] -> Tree a
    const Node = (v, xs) => ({
        type: 'Node',
        root: v, // any type of value (consistent across tree)
        nest: xs || []
    });

    // append (++) :: [a] -> [a] -> [a]
    // append (++) :: String -> String -> String
    const append = (xs, ys) => xs.concat(ys);

    // chars :: String -> [Char]
    const chars = s => s.split('');

    // cons :: a -> [a] -> [a]
    const cons = (x, xs) => [x].concat(xs);

    // Returns Infinity over objects without finite length.
    // This enables zip and zipWith to choose the shorter
    // argument when one is non-finite, like cycle, repeat etc

    // length :: [a] -> Int
    const length = xs =>
        (Array.isArray(xs) || 'string' === typeof xs) ? (
            xs.length
        ) : Infinity;

    // lines :: String -> [String]
    const lines = s => s.split(/[\r\n]/);

    // replicate :: Int -> a -> [a]
    const replicate = (n, x) =>
        Array.from({
            length: n
        }, () => x);

    // take :: Int -> [a] -> [a]
    const take = (n, xs) =>
        xs.slice(0, n);

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // Use of `take` and `length` here allows zipping with non-finite lists
    // i.e. generators like cycle, repeat, iterate.

    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = (f, xs, ys) => {
        const
            lng = Math.min(length(xs), length(ys)),
            as = take(lng, xs),
            bs = take(lng, ys);
        return Array.from({
            length: lng
        }, (_, i) => f(as[i], bs[i], i));
    };

    // MAIN ---
    return main();
})();
