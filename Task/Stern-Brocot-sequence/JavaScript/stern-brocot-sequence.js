(() => {
    'use strict';

    const main = () => {

        // sternBrocot :: Generator [Int]
        const sternBrocot = () => {
            const go = xs => {
                const x = snd(xs);
                return tail(append(xs, [fst(xs) + x, x]));
            };
            return fmapGen(head, iterate(go, [1, 1]));
        };


        // TESTS ------------------------------------------
        const
            sbs = take(1200, sternBrocot()),
            ixSB = zip(sbs, enumFrom(1));

        return unlines(map(
            JSON.stringify,
            [
                take(15, sbs),
                take(10,
                    map(listFromTuple,
                        nubBy(
                            on(eq, fst),
                            sortBy(
                                comparing(fst),
                                takeWhile(x => 12 !== fst(x), ixSB)
                            )
                        )
                    )
                ),
                listFromTuple(
                    take(1, dropWhile(x => 100 !== fst(x), ixSB))[0]
                ),
                all(tpl => 1 === gcd(fst(tpl), snd(tpl)),
                    take(1000, zip(sbs, tail(sbs)))
                )
            ]
        ));
    };

    // GENERIC ABSTRACTIONS -------------------------------

    // Just :: a -> Maybe a
    const Just = x => ({
        type: 'Maybe',
        Nothing: false,
        Just: x
    });

    // Nothing :: Maybe a
    const Nothing = () => ({
        type: 'Maybe',
        Nothing: true,
    });

    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = (a, b) => ({
        type: 'Tuple',
        '0': a,
        '1': b,
        length: 2
    });

    // | Absolute value.

    // abs :: Num -> Num
    const abs = Math.abs;

    // Determines whether all elements of the structure
    // satisfy the predicate.

    // all :: (a -> Bool) -> [a] -> Bool
    const all = (p, xs) => xs.every(p);

    // append (++) :: [a] -> [a] -> [a]
    // append (++) :: String -> String -> String
    const append = (xs, ys) => xs.concat(ys);

    // chr :: Int -> Char
    const chr = String.fromCodePoint;

    // comparing :: (a -> b) -> (a -> a -> Ordering)
    const comparing = f =>
        (x, y) => {
            const
                a = f(x),
                b = f(y);
            return a < b ? -1 : (a > b ? 1 : 0);
        };

    // dropWhile :: (a -> Bool) -> [a] -> [a]
    // dropWhile :: (Char -> Bool) -> String -> String
    const dropWhile = (p, xs) => {
        const lng = xs.length;
        return 0 < lng ? xs.slice(
            until(
                i => i === lng || !p(xs[i]),
                i => 1 + i,
                0
            )
        ) : [];
    };

    // enumFrom :: a -> [a]
    function* enumFrom(x) {
        let v = x;
        while (true) {
            yield v;
            v = succ(v);
        }
    }

    // eq (==) :: Eq a => a -> a -> Bool
    const eq = (a, b) => {
        const t = typeof a;
        return t !== typeof b ? (
            false
        ) : 'object' !== t ? (
            'function' !== t ? (
                a === b
            ) : a.toString() === b.toString()
        ) : (() => {
            const aks = Object.keys(a);
            return aks.length !== Object.keys(b).length ? (
                false
            ) : aks.every(k => eq(a[k], b[k]));
        })();
    };

    // fmapGen <$> :: (a -> b) -> Gen [a] -> Gen [b]
    function* fmapGen(f, gen) {
        const g = gen;
        let v = take(1, g)[0];
        while (0 < v.length) {
            yield(f(v))
            v = take(1, g)[0]
        }
    }

    // fst :: (a, b) -> a
    const fst = tpl => tpl[0];

    // gcd :: Int -> Int -> Int
    const gcd = (x, y) => {
        const
            _gcd = (a, b) => (0 === b ? a : _gcd(b, a % b)),
            abs = Math.abs;
        return _gcd(abs(x), abs(y));
    };

    // head :: [a] -> a
    const head = xs => xs.length ? xs[0] : undefined;

    // isChar :: a -> Bool
    const isChar = x =>
        ('string' === typeof x) && (1 === x.length);

    // iterate :: (a -> a) -> a -> Gen [a]
    function* iterate(f, x) {
        let v = x;
        while (true) {
            yield(v);
            v = f(v);
        }
    }

    // Returns Infinity over objects without finite length
    // this enables zip and zipWith to choose the shorter
    // argument when one is non-finite, like cycle, repeat etc

    // length :: [a] -> Int
    const length = xs => xs.length || Infinity;

    // listFromTuple :: (a, a ...) -> [a]
    const listFromTuple = tpl =>
        Array.from(tpl);

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f);

    // nubBy :: (a -> a -> Bool) -> [a] -> [a]
    const nubBy = (p, xs) => {
        const go = xs => 0 < xs.length ? (() => {
            const x = xs[0];
            return [x].concat(
                go(xs.slice(1)
                    .filter(y => !p(x, y))
                )
            )
        })() : [];
        return go(xs);
    };

    // e.g. sortBy(on(compare,length), xs)

    // on :: (b -> b -> c) -> (a -> b) -> a -> a -> c
    const on = (f, g) => (a, b) => f(g(a), g(b));

    // ord :: Char -> Int
    const ord = c => c.codePointAt(0);

    // snd :: (a, b) -> b
    const snd = tpl => tpl[1];

    // sortBy :: (a -> a -> Ordering) -> [a] -> [a]
    const sortBy = (f, xs) =>
        xs.slice()
        .sort(f);

    // succ :: Enum a => a -> a
    const succ = x =>
        isChar(x) ? (
            chr(1 + ord(x))
        ) : isNaN(x) ? (
            undefined
        ) : 1 + x;

    // tail :: [a] -> [a]
    const tail = xs => 0 < xs.length ? xs.slice(1) : [];

    // take :: Int -> [a] -> [a]
    // take :: Int -> String -> String
    const take = (n, xs) =>
        xs.constructor.constructor.name !== 'GeneratorFunction' ? (
            xs.slice(0, n)
        ) : [].concat.apply([], Array.from({
            length: n
        }, () => {
            const x = xs.next();
            return x.done ? [] : [x.value];
        }));

    // takeWhile :: (a -> Bool) -> [a] -> [a]
    // takeWhile :: (Char -> Bool) -> String -> String
    const takeWhile = (p, xs) =>
        xs.constructor.constructor.name !==
        'GeneratorFunction' ? (() => {
            const lng = xs.length;
            return 0 < lng ? xs.slice(
                0,
                until(
                    i => lng === i || !p(xs[i]),
                    i => 1 + i,
                    0
                )
            ) : [];
        })() : takeWhileGen(p, xs);

    // takeWhileGen :: (a -> Bool) -> Gen [a] -> [a]
    const takeWhileGen = (p, xs) => {
        const ys = [];
        let
            nxt = xs.next(),
            v = nxt.value;
        while (!nxt.done && p(v)) {
            ys.push(v);
            nxt = xs.next();
            v = nxt.value
        }
        return ys;
    };

    // uncons :: [a] -> Maybe (a, [a])
    const uncons = xs => {
        const lng = length(xs);
        return (0 < lng) ? (
            lng < Infinity ? (
                Just(Tuple(xs[0], xs.slice(1))) // Finite list
            ) : (() => {
                const nxt = take(1, xs);
                return 0 < nxt.length ? (
                    Just(Tuple(nxt[0], xs))
                ) : Nothing();
            })() // Lazy generator
        ) : Nothing();
    };

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // until :: (a -> Bool) -> (a -> a) -> a -> a
    const until = (p, f, x) => {
        let v = x;
        while (!p(v)) v = f(v);
        return v;
    };

    // Use of `take` and `length` here allows for zipping with non-finite
    // lists - i.e. generators like cycle, repeat, iterate.

    // zip :: [a] -> [b] -> [(a, b)]
    const zip = (xs, ys) => {
        const lng = Math.min(length(xs), length(ys));
        return Infinity !== lng ? (() => {
            const bs = take(lng, ys);
            return take(lng, xs).map((x, i) => Tuple(x, bs[i]));
        })() : zipGen(xs, ys);
    };

    // zipGen :: Gen [a] -> Gen [b] -> Gen [(a, b)]
    const zipGen = (ga, gb) => {
        function* go(ma, mb) {
            let
                a = ma,
                b = mb;
            while (!a.Nothing && !b.Nothing) {
                let
                    ta = a.Just,
                    tb = b.Just
                yield(Tuple(fst(ta), fst(tb)));
                a = uncons(snd(ta));
                b = uncons(snd(tb));
            }
        }
        return go(uncons(ga), uncons(gb));
    };

    // MAIN ---
    return main();
})();
