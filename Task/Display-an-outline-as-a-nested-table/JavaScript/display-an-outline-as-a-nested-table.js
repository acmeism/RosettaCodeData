(() => {
    "use strict";

    // ----------- NESTED TABLES FROM OUTLINE ------------

    // wikiTablesFromOutline :: [String] -> String -> String
    const wikiTablesFromOutline = colorSwatch =>
        outline => forestFromIndentedLines(
            indentLevelsFromLines(lines(outline))
        )
        .map(wikiTableFromTree(colorSwatch))
        .join("\n\n");


    // wikiTableFromTree :: [String] -> Tree String -> String
    const wikiTableFromTree = colorSwatch =>
        compose(
            wikiTableFromRows,
            levels,
            paintedTree(colorSwatch),
            widthLabelledTree,
            ap(paddedTree(""))(treeDepth)
        );

    // ---------------------- TEST -----------------------
    // main :: IO ()
    const main = () => {
        const outline = `Display an outline as a nested table.
    Parse the outline to a tree,
        measuring the indent of each line,
        translating the indentation to a nested structure,
        and padding the tree to even depth.
    count the leaves descending from each node,
        defining the width of a leaf as 1,
        and the width of a parent node as a sum.
            (The sum of the widths of its children)
    and write out a table with 'colspan' values
        either as a wiki table,
        or as HTML.`;

        return wikiTablesFromOutline([
            "#ffffe6",
            "#ffebd2",
            "#f0fff0",
            "#e6ffff",
            "#ffeeff"
        ])(outline);
    };

    // --------- TREE STRUCTURE FROM NESTED TEXT ---------

    // forestFromIndentedLines :: [(Int, String)] ->
    // [Tree String]
    const forestFromIndentedLines = tuples => {
        const go = xs =>
            0 < xs.length ? (() => {
                // First line and its sub-tree,
                const [indented, body] = Array.from(
                        xs[0]
                    ),
                    [tree, rest] = Array.from(
                        span(compose(lt(indented), fst))(
                            tail(xs)
                        )
                    );

                // followed by the rest.
                return [
                    Node(body)(go(tree))
                ].concat(go(rest));
            })() : [];

        return go(tuples);
    };


    // indentLevelsFromLines :: [String] -> [(Int, String)]
    const indentLevelsFromLines = xs => {
        const
            pairs = xs.map(
                x => bimap(length)(cs => cs.join(""))(
                    span(isSpace)(list(x))
                )
            ),
            indentUnit = pairs.reduce(
                (a, tpl) => {
                    const i = tpl[0];

                    return 0 < i ? (
                        i < a ? i : a
                    ) : a;
                },
                Infinity
            );

        return [Infinity, 0].includes(indentUnit) ? (
            pairs
        ) : pairs.map(first(n => n / indentUnit));
    };

    // ------------ TREE PADDED TO EVEN DEPTH ------------

    // paddedTree :: a -> Tree a -> Int -> Tree a
    const paddedTree = padValue =>
        // All descendants expanded to same depth
        // with empty nodes where needed.
        node => depth => {
            const go = n => tree =>
                1 < n ? (() => {
                    const children = nest(tree);

                    return Node(root(tree))(
                        (
                            0 < children.length ? (
                                children
                            ) : [Node(padValue)([])]
                        ).map(go(n - 1))
                    );
                })() : tree;

            return go(depth)(node);
        };

    // treeDepth :: Tree a -> Int
    const treeDepth = tree =>
        foldTree(
            () => xs => 0 < xs.length ? (
                1 + maximum(xs)
            ) : 1
        )(tree);

    // ------------- SUBTREE WIDTHS MEASURED -------------

    // widthLabelledTree :: Tree a -> Tree (a, Int)
    const widthLabelledTree = tree =>
        // A tree in which each node is labelled with
        // the width of its own subtree.
        foldTree(x => xs =>
            0 < xs.length ? (
                Node(Tuple(x)(
                    xs.reduce(
                        (a, node) => a + snd(root(node)),
                        0
                    )
                ))(xs)
            ) : Node(Tuple(x)(1))([])
        )(tree);

    // -------------- COLOR SWATCH APPLIED ---------------

    // paintedTree :: [String] -> Tree a -> Tree (String, a)
    const paintedTree = colorSwatch =>
        tree => 0 < colorSwatch.length ? (
            Node(
                Tuple(colorSwatch[0])(root(tree))
            )(
                zipWith(compose(fmapTree, Tuple))(
                    cycle(colorSwatch.slice(1))
                )(
                    nest(tree)
                )
            )
        ) : fmapTree(Tuple(""))(tree);

    // --------------- WIKITABLE RENDERED ----------------

    // wikiTableFromRows ::
    // [[(String, (String, Int))]] -> String
    const wikiTableFromRows = rows => {
        const
            cw = color => width => {
                const go = w =>
                    1 < w ? (
                        `colspan=${w} `
                    ) : "";

                return `style="background:${color}; "` + (
                    ` ${go(width)}`
                );
            },
            cellText = ctw => {
                const [color, tw] = Array.from(ctw);
                const [txt, width] = Array.from(tw);

                return 0 < txt.length ? (
                    `| ${cw(color)(width)}| ${txt}`
                ) : "| |";
            },
            classText = "class=\"wikitable\"",
            styleText = "style=\"text-align:center;\"",
            header = `{| ${classText} ${styleText}\n|-`,
            tableBody = rows.map(
                cells => cells.map(cellText).join("\n")
            ).join("\n|-\n");

        return `${header}\n${tableBody}\n|}`;
    };

    // ------------------ GENERIC TREES ------------------

    // Node :: a -> [Tree a] -> Tree a
    const Node = v =>
        // Constructor for a Tree node which connects a
        // value of some kind to a list of zero or
        // more child trees.
        xs => ({
            type: "Node",
            root: v,
            nest: xs || []
        });


    // fmapTree :: (a -> b) -> Tree a -> Tree b
    const fmapTree = f => {
        // A new tree. The result of a
        // structure-preserving application of f
        // to each root in the existing tree.
        const go = t => Node(
            f(t.root)
        )(
            t.nest.map(go)
        );

        return go;
    };


    // foldTree :: (a -> [b] -> b) -> Tree a -> b
    const foldTree = f => {
        // The catamorphism on trees. A summary
        // value obtained by a depth-first fold.
        const go = tree => f(
            root(tree)
        )(
            nest(tree).map(go)
        );

        return go;
    };


    // levels :: Tree a -> [[a]]
    const levels = tree => {
        // A list of lists, grouping the root
        // values of each level of the tree.
        const go = (a, node) => {
            const [h, ...t] = 0 < a.length ? (
                a
            ) : [
                [],
                []
            ];

            return [
                [node.root, ...h],
                ...node.nest.slice(0)
                .reverse()
                .reduce(go, t)
            ];
        };

        return go([], tree);
    };


    // nest :: Tree a -> [a]
    const nest = tree => {
        // Allowing for lazy (on-demand) evaluation.
        // If the nest turns out to be a function –
        // rather than a list – that function is applied
        // here to the root, and returns a list.
        const xs = tree.nest;

        return "function" !== typeof xs ? (
            xs
        ) : xs(root(tree));
    };


    // root :: Tree a -> a
    const root = tree =>
        // The value attached to a tree node.
        tree.root;

    // --------------------- GENERIC ---------------------

    // Just :: a -> Maybe a
    const Just = x => ({
        type: "Maybe",
        Nothing: false,
        Just: x
    });


    // Nothing :: Maybe a
    const Nothing = () => ({
        type: "Maybe",
        Nothing: true
    });


    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = a =>
        b => ({
            type: "Tuple",
            "0": a,
            "1": b,
            length: 2
        });


    // apFn :: (a -> b -> c) -> (a -> b) -> (a -> c)
    const ap = f =>
        // Applicative instance for functions.
        // f(x) applied to g(x).
        g => x => f(x)(
            g(x)
        );


    // bimap :: (a -> b) -> (c -> d) -> (a, c) -> (b, d)
    const bimap = f =>
        // Tuple instance of bimap.
        // A tuple of the application of f and g to the
        // first and second values respectively.
        g => tpl => Tuple(f(tpl[0]))(
            g(tpl[1])
        );


    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (...fs) =>
        // A function defined by the right-to-left
        // composition of all the functions in fs.
        fs.reduce(
            (f, g) => x => f(g(x)),
            x => x
        );


    // cycle :: [a] -> Generator [a]
    const cycle = function* (xs) {
        // An infinite repetition of xs,
        // from which an arbitrary prefix
        // may be taken.
        const lng = xs.length;
        let i = 0;

        while (true) {
            yield xs[i];
            i = (1 + i) % lng;
        }
    };


    // first :: (a -> b) -> ((a, c) -> (b, c))
    const first = f =>
        // A simple function lifted to one which applies
        // to a tuple, transforming only its first item.
        xy => {
            const tpl = Tuple(f(xy[0]))(xy[1]);

            return Array.isArray(xy) ? (
                Array.from(tpl)
            ) : tpl;
        };


    // fst :: (a, b) -> a
    const fst = tpl =>
        // First member of a pair.
        tpl[0];


    // isSpace :: Char -> Bool
    const isSpace = c =>
        // True if c is a white space character.
        (/\s/u).test(c);


    // length :: [a] -> Int
    const length = xs =>
        // Returns Infinity over objects without finite
        // length. This enables zip and zipWith to choose
        // the shorter argument when one is non-finite,
        // like cycle, repeat etc
        "GeneratorFunction" !== xs.constructor
        .constructor.name ? (
            xs.length
        ) : Infinity;


    // lines :: String -> [String]
    const lines = s =>
        // A list of strings derived from a single
        // string delimited by newline and or CR.
        0 < s.length ? (
            s.split(/[\r\n]+/u)
        ) : [];


    // list :: StringOrArrayLike b => b -> [a]
    const list = xs =>
        // xs itself, if it is an Array,
        // or an Array derived from xs.
        Array.isArray(xs) ? (
            xs
        ) : Array.from(xs || []);


    // lt (<) :: Ord a => a -> a -> Bool
    const lt = a =>
        b => a < b;


    // maximum :: Ord a => [a] -> a
    const maximum = xs => (
        // The largest value in a non-empty list.
        ys => 0 < ys.length ? (
            ys.slice(1).reduce(
                (a, y) => y > a ? (
                    y
                ) : a, ys[0]
            )
        ) : undefined
    )(list(xs));


    // snd :: (a, b) -> b
    const snd = tpl =>
        // Second member of a pair.
        tpl[1];


    // span :: (a -> Bool) -> [a] -> ([a], [a])
    const span = p =>
        // Longest prefix of xs consisting of elements which
        // all satisfy p, tupled with the remainder of xs.
        xs => {
            const i = xs.findIndex(x => !p(x));

            return -1 !== i ? (
                Tuple(xs.slice(0, i))(
                    xs.slice(i)
                )
            ) : Tuple(xs)([]);
        };


    // tail :: [a] -> [a]
    const tail = xs =>
        // A new list consisting of all
        // items of xs except the first.
        "GeneratorFunction" !== xs.constructor
        .constructor.name ? (
            (ys => 0 < ys.length ? ys.slice(1) : [])(
                xs
            )
        ) : (take(1)(xs), xs);


    // take :: Int -> [a] -> [a]
    // take :: Int -> String -> String
    const take = n =>
        // The first n elements of a list,
        // string of characters, or stream.
        xs => "GeneratorFunction" !== xs
        .constructor.constructor.name ? (
            xs.slice(0, n)
        ) : [].concat(...Array.from({
            length: n
        }, () => {
            const x = xs.next();

            return x.done ? [] : [x.value];
        }));


    // uncons :: [a] -> Maybe (a, [a])
    const uncons = xs => {
        // Just a tuple of the head of xs and its tail,
        // Or Nothing if xs is an empty list.
        const lng = length(xs);

        return (0 < lng) ? (
            Infinity > lng ? (
                // Finite list
                Just(Tuple(xs[0])(xs.slice(1)))
            ) : (() => {
                // Lazy generator
                const nxt = take(1)(xs);

                return 0 < nxt.length ? (
                    Just(Tuple(nxt[0])(xs))
                ) : Nothing();
            })()
        ) : Nothing();
    };


    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = f =>
        // A list with the length of the shorter of
        // xs and ys, defined by zipping with a
        // custom function, rather than with the
        // default tuple constructor.
        xs => ys => {
            const n = Math.min(length(xs), length(ys));

            return Infinity > n ? (
                (([as, bs]) => Array.from({
                    length: n
                }, (_, i) => f(as[i])(
                    bs[i]
                )))([xs, ys].map(
                    take(n)
                ))
            ) : zipWithGen(f)(xs)(ys);
        };


    // zipWithGen :: (a -> b -> c) ->
    // Gen [a] -> Gen [b] -> Gen [c]
    const zipWithGen = f => ga => gb => {
        const go = function* (ma, mb) {
            let
                a = ma,
                b = mb;

            while (!a.Nothing && !b.Nothing) {
                const
                    ta = a.Just,
                    tb = b.Just;

                yield f(fst(ta))(fst(tb));
                a = uncons(snd(ta));
                b = uncons(snd(tb));
            }
        };

        return go(uncons(ga), uncons(gb));
    };

    // MAIN ---
    return main();
})();
