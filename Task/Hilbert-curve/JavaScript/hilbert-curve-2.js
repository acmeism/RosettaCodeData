(() => {
    "use strict";

    // ------------------ HILBERT CURVE ------------------

    // hilbertCurve :: Dict Char [(Int, Int)] ->
    // Dict Char [Char] -> Int -> Int -> SVG string
    const hilbertCurve = dictVector =>
        dictRule => width => compose(
            svgFromPoints(width),
            hilbertPoints(dictVector)(width),
            hilbertTree(dictRule)
        );


    // hilbertTree :: Dict Char [Char] -> Int -> Tree Char
    const hilbertTree = rule =>
        n => {
            const go = tree => {
                const xs = tree.nest;

                return Node(tree.root)(
                    0 < xs.length
                        ? xs.map(go)
                        : rule[tree.root].map(
                            flip(Node)([])
                        )
                );
            };
            const seed = Node("a")([]);

            return 0 < n
                ? take(n)(
                    iterate(go)(seed)
                )
                .slice(-1)[0]
                : seed;
        };


    // hilbertPoints :: Size -> Tree Char -> [(x, y)]
    // hilbertPoints :: Int -> Tree Char -> [(Int, Int)]
    const hilbertPoints = dict =>
        w => tree => {
            const go = d => (xy, t) => {
                const
                    r = Math.floor(d / 2),
                    centres = dict[t.root]
                    .map(v => [
                        xy[0] + (r * v[0]),
                        xy[1] + (r * v[1])
                    ]);

                return 0 < t.nest.length
                    ? zipWith(
                        go(r)
                    )(centres)(t.nest).flat()
                    : centres;
            };
            const d = Math.floor(w / 2);

            return go(d)([d, d], tree);
        };


    // svgFromPoints :: Int -> [(Int, Int)] -> String
    const svgFromPoints = w => xys => [
        "<svg xmlns=\"http://www.w3.org/2000/svg\"",
        `width="500" height="500" viewBox="5 5 ${w} ${w}">`,
        `<path d="M${(xys).flat().join(" ")}" `,
        // eslint-disable-next-line quotes
        'stroke-width="2" stroke="red" fill="transparent"/>',
        "</svg>"
    ].join("\n");


    // -------------------- TEST ---------------------
    const main = () =>
        hilbertCurve({
            "a": [
                [-1, 1],
                [-1, -1],
                [1, -1],
                [1, 1]
            ],
            "b": [
                [1, -1],
                [-1, -1],
                [-1, 1],
                [1, 1]
            ],
            "c": [
                [1, -1],
                [1, 1],
                [-1, 1],
                [-1, -1]
            ],
            "d": [
                [-1, 1],
                [1, 1],
                [1, -1],
                [-1, -1]
            ]
        })({
            a: ["d", "a", "a", "b"],
            b: ["c", "b", "b", "a"],
            c: ["b", "c", "c", "d"],
            d: ["a", "d", "d", "c"]
        })(1024)(6);


    // ---------------- GENERIC FUNCTIONS ----------------

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


    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (...fs) =>
    // A function defined by the right-to-left
    // composition of all the functions in fs.
        fs.reduce(
            (f, g) => x => f(g(x)),
            x => x
        );


    // flip :: (a -> b -> c) -> b -> a -> c
    const flip = op =>
    // The binary function op with
    // its arguments reversed.
        1 !== op.length
            ? (a, b) => op(b, a)
            : (a => b => op(b)(a));


    // iterate :: (a -> a) -> a -> Gen [a]
    const iterate = f =>
        // An infinite list of repeated applications
        // of f, starting with the seed value x.
        function* (x) {
            let v = x;

            while (true) {
                yield v;
                v = f(v);
            }
        };


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


    // take :: Int -> [a] -> [a]
    // take :: Int -> String -> String
    const take = n =>
        // The first n elements of a list,
        // string of characters, or stream.
        xs => "GeneratorFunction" !== xs
        .constructor.constructor.name ? (
                xs.slice(0, n)
            ) : Array.from({
                length: n
            }, () => {
                const x = xs.next();

                return x.done ? [] : [x.value];
            }).flat();


    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = f =>
        xs => ys => {
            const
                n = Math.min(length(xs), length(ys)),
                as = take(n)(xs),
                bs = take(n)(ys);

            return Array.from({
                length: n
            }, (_, i) => f(as[i], bs[i]));
        };


    // MAIN ---
    return main();
})();
