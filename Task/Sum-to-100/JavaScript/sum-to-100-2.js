(() => {
    'use strict';

    // GENERIC FUNCTIONS ----------------------------------------------------

    // permutationsWithRepetition :: Int -> [a] -> [[a]]
    const permutationsWithRepetition = (n, as) =>
        as.length > 0 ? (
            foldl1(curry(cartesianProduct)(as), replicate(n, as))
        ) : [];

    // cartesianProduct :: [a] -> [b] -> [[a, b]]
    const cartesianProduct = (xs, ys) =>
        [].concat.apply([], xs.map(x =>
        [].concat.apply([], ys.map(y => [[x].concat(y)]))));

    // curry :: ((a, b) -> c) -> a -> b -> c
    const curry = f => a => b => f(a, b);

    // flip :: (a -> b -> c) -> b -> a -> c
    const flip = f => (a, b) => f.apply(null, [b, a]);

    // foldl1 :: (a -> a -> a) -> [a] -> a
    const foldl1 = (f, xs) =>
        xs.length > 0 ? xs.slice(1)
        .reduce(f, xs[0]) : [];

    // replicate :: Int -> a -> [a]
    const replicate = (n, a) => {
        let v = [a],
            o = [];
        if (n < 1) return o;
        while (n > 1) {
            if (n & 1) o = o.concat(v);
            n >>= 1;
            v = v.concat(v);
        }
        return o.concat(v);
    };

    // group :: Eq a => [a] -> [[a]]
    const group = xs => groupBy((a, b) => a === b, xs);

    // groupBy :: (a -> a -> Bool) -> [a] -> [[a]]
    const groupBy = (f, xs) => {
        const dct = xs.slice(1)
            .reduce((a, x) => {
                const
                    h = a.active.length > 0 ? a.active[0] : undefined,
                    blnGroup = h !== undefined && f(h, x);

                return {
                    active: blnGroup ? a.active.concat(x) : [x],
                    sofar: blnGroup ? a.sofar : a.sofar.concat([a.active])
                };
            }, {
                active: xs.length > 0 ? [xs[0]] : [],
                sofar: []
            });
        return dct.sofar.concat(dct.active.length > 0 ? [dct.active] : []);
    };

    // compare :: a -> a -> Ordering
    const compare = (a, b) => a < b ? -1 : (a > b ? 1 : 0);

    // on :: (b -> b -> c) -> (a -> b) -> a -> a -> c
    const on = (f, g) => (a, b) => f(g(a), g(b));

    // nub :: [a] -> [a]
    const nub = xs => nubBy((a, b) => a === b, xs);

    // nubBy :: (a -> a -> Bool) -> [a] -> [a]
    const nubBy = (p, xs) => {
        const x = xs.length ? xs[0] : undefined;

        return x !== undefined ? [x].concat(
            nubBy(p, xs.slice(1)
                .filter(y => !p(x, y)))
        ) : [];
    };

    // find :: (a -> Bool) -> [a] -> Maybe a
    const find = (f, xs) => {
        for (var i = 0, lng = xs.length; i < lng; i++) {
            if (f(xs[i], i)) return xs[i];
        }
        return undefined;
    }

    // Int -> [a] -> [a]
    const take = (n, xs) => xs.slice(0, n);

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // show :: a -> String
    const show = x => JSON.stringify(x); //, null, 2);

    // head :: [a] -> a
    const head = xs => xs.length ? xs[0] : undefined;

    // tail :: [a] -> [a]
    const tail = xs => xs.length ? xs.slice(1) : undefined;

    // length :: [a] -> Int
    const length = xs => xs.length;


    // SIGNED DIGIT SEQUENCES  (mapped to sums and to strings)

    // data Sign :: [ 0 | 1 | -1 ] = ( Unsigned | Plus | Minus )
    // asSum :: [Sign] -> Int
    const asSum = xs => {
        const dct = xs.reduceRight((a, sign, i) => {
            const d = i + 1; //  zero-based index to [1-9] positions
            if (sign !== 0) { // Sum increased, digits cleared
                return {
                    digits: [],
                    n: a.n + (sign * parseInt([d].concat(a.digits)
                        .join(''), 10))
                };
            } else return { // Digits extended, sum unchanged
                digits: [d].concat(a.digits),
                n: a.n
            };
        }, {
            digits: [],
            n: 0
        });
        return dct.n + (dct.digits.length > 0 ? (
            parseInt(dct.digits.join(''), 10)
        ) : 0);
    };

    // data Sign :: [ 0 | 1 | -1 ] = ( Unsigned | Plus | Minus )
    // asString :: [Sign] -> String
    const asString = xs => {
        const ns = xs.reduce((a, sign, i) => {
            const d = (i + 1)
                .toString();
            return (sign === 0 ? (
                a + d
            ) : (a + (sign > 0 ? ' +' : ' -') + d));
        }, '');

        return ns[0] === '+' ? tail(ns) : ns;
    };


    // SUM T0 100 ------------------------------------------------------------

    // universe :: [[Sign]]
    const universe = permutationsWithRepetition(9, [0, 1, -1])
        .filter(x => x[0] !== 1);

    // allNonNegativeSums :: [Int]
    const allNonNegativeSums = universe.map(asSum)
        .filter(x => x >= 0)
        .sort();

    // uniqueNonNegativeSums :: [Int]
    const uniqueNonNegativeSums = nub(allNonNegativeSums);


    return [
        "Sums to 100:\n",
        unlines(universe.filter(x => asSum(x) === 100)
            .map(asString)),

        "\n\n10 commonest sums (sum, followed by number of routes to it):\n",
        show(take(10, group(allNonNegativeSums)
            .sort(on(flip(compare), length))
            .map(xs => [xs[0], xs.length]))),

        "\n\nFirst positive integer not expressible as a sum of this kind:\n",
        show(find(
            (x, i) => x !== i,
            uniqueNonNegativeSums.sort(compare)
        ) - 1), // i is the the zero-based Array index.

        "\n10 largest sums:\n",
        show(take(10, uniqueNonNegativeSums.sort(flip(compare))))
    ].join('\n') + '\n';
})();
