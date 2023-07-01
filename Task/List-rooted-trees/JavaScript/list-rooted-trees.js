(() => {
    'use strict';

    const main = () =>
        bagPatterns(5)
        .join('\n');

    // BAG PATTERNS ---------------------------------------

    // bagPatterns :: Int -> [String]
    const bagPatterns = n =>
        nub(map(
            composeList([
                commasFromTree,
                depthSortedTree,
                treeFromParentIndices
            ]),
            parentIndexPermutations(n)
        ));

    // parentIndexPermutations :: Int -> [[Int]]
    const parentIndexPermutations = n =>
        sequenceA(
            map(curry(enumFromToInt)(0),
                enumFromToInt(0, n - 2)
            )
        );

    // treeFromParentIndices :: [Int] -> Tree Int
    const treeFromParentIndices = pxs => {
        const go = (tree, tplIP) =>
            Node(
                tree.root,
                tree.root === snd(tplIP) ? (
                    tree.nest.concat(Node(fst(tplIP)), [])
                ) : map(t => go(t, tplIP), tree.nest)
            );
        return foldl(
            go, Node(0, []),
            zip(enumFromToInt(1, pxs.length), pxs)
        );
    };

    // Siblings sorted by descendant count

    // depthSortedTree :: Tree a -> Tree Int
    const depthSortedTree = t => {
        const go = tree =>
            isNull(tree.nest) ? (
                Node(0, [])
            ) : (() => {
                const xs = map(go, tree.nest);
                return Node(
                    1 + foldl((a, x) => a + x.root, 0, xs),
                    sortBy(flip(comparing(x => x.root)), xs)
                );
            })();
        return go(t);
    };

    // Serialisation of the tree structure

    // commasFromTree :: Tree a -> String
    const commasFromTree = tree => {
        const go = t => `(${concat(map(go, t.nest))})`
        return go(tree);
    };


    // GENERIC FUNCTIONS --------------------------------------

    // Node :: a -> [Tree a] -> Tree a
    const Node = (v, xs) => ({
        type: 'Node',
        root: v, // any type of value (but must be consistent across tree)
        nest: xs || []
    });

    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = (a, b) => ({
        type: 'Tuple',
        '0': a,
        '1': b,
        length: 2
    });

    // comparing :: (a -> b) -> (a -> a -> Ordering)
    const comparing = f =>
        (x, y) => {
            const
                a = f(x),
                b = f(y);
            return a < b ? -1 : (a > b ? 1 : 0);
        };

    // composeList :: [(a -> a)] -> (a -> a)
    const composeList = fs =>
        x => fs.reduceRight((a, f) => f(a), x, fs);

    // concat :: [[a]] -> [a]
    // concat :: [String] -> String
    const concat = xs =>
        xs.length > 0 ? (() => {
            const unit = typeof xs[0] === 'string' ? '' : [];
            return unit.concat.apply(unit, xs);
        })() : [];

        // concatMap :: (a -> [b]) -> [a] -> [b]
    const concatMap = (f, xs) => []
        .concat.apply(
            [],
            (Array.isArray(xs) ? (
                xs
            ) : xs.split('')).map(f)
        );

        // cons :: a -> [a] -> [a]
    const cons = (x, xs) =>  [x].concat(xs);

    // Flexibly handles two or more arguments, applying
    // the function directly if the argument array is complete,
    // or recursing with a concatenation of any existing and
    // newly supplied arguments, if gaps remain.
    // curry :: ((a, b) -> c) -> a -> b -> c
    const curry = (f, ...args) => {
        const go = xs => xs.length >= f.length ? (
            f.apply(null, xs)
        ) : function() {
            return go(xs.concat(Array.from(arguments)));
        };
        return go(args);
    };

    // enumFromToInt :: Int -> Int -> [Int]
    const enumFromToInt = (m, n) =>
        n >= m ? (
            iterateUntil(x => x >= n, x => 1 + x, m)
        ) : [];

    // flip :: (a -> b -> c) -> b -> a -> c
    const flip = f => (a, b) => f.apply(null, [b, a]);

    // foldl :: (a -> b -> a) -> a -> [b] -> a
    const foldl = (f, a, xs) => xs.reduce(f, a);

    // fst :: (a, b) -> a
    const fst = tpl => tpl[0];

    // isNull :: [a] -> Bool
    // isNull :: String -> Bool
    const isNull = xs =>
        Array.isArray(xs) || typeof xs === 'string' ? (
            xs.length < 1
        ) : undefined;

    // iterateUntil :: (a -> Bool) -> (a -> a) -> a -> [a]
    const iterateUntil = (p, f, x) => {
        let vs = [x],
            h = x;
        while (!p(h))(h = f(h), vs.push(h));
        return vs;
    };

    // liftA2List :: (a -> b -> c) -> [a] -> [b] -> [c]
    const liftA2List = (f, xs, ys) =>
        concatMap(x => concatMap(y => [f(x, y)], ys), xs);

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f);

    // nub :: [a] -> [a]
    const nub = xs => nubBy((a, b) => a === b, xs);

    // nubBy :: (a -> a -> Bool) -> [a] -> [a]
    const nubBy = (p, xs) => {
        const go = xs => xs.length > 0 ? (() => {
            const x = xs[0];
            return [x].concat(
                go(xs.slice(1)
                    .filter(y => !p(x, y))
                )
            )
        })() : [];
        return go(xs);
    };

    // sequenceA :: (Applicative f, Traversable t) => t (f a) -> f (t a)
    const sequenceA = tfa =>
        traverseList(x => x, tfa);

    // traverseList :: (Applicative f) => (a -> f b) -> [a] -> f [b]
    const traverseList = (f, xs) => {
        const lng = xs.length;
        return 0 < lng ? (() => {
            const
                vLast = f(xs[lng - 1]),
                t = vLast.type || 'List';
            return xs.slice(0, -1).reduceRight(
                (ys, x) => liftA2List(cons, f(x), ys),
                liftA2List(cons, vLast, [[]])
            );
        })() : [
            []
        ];
    };

    // snd :: (a, b) -> b
    const snd = tpl => tpl[1];

    // sortBy :: (a -> a -> Ordering) -> [a] -> [a]
    const sortBy = (f, xs) =>
        xs.slice()
        .sort(f);

    // zip :: [a] -> [b] -> [(a, b)]
    const zip = (xs, ys) =>
        xs.slice(0, Math.min(xs.length, ys.length))
        .map((x, i) => Tuple(x, ys[i]));

    // MAIN ---
    return main()
})();
