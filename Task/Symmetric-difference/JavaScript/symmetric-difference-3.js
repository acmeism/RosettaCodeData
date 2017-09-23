(() => {
    'use strict';

    const symmetricDifference = (xs, ys) =>
        union(difference(xs, ys), difference(ys, xs));


    // GENERIC FUNCTIONS ------------------------------------------------------

    // First instance of x (if any) removed from xs
    // delete_ :: Eq a => a -> [a] -> [a]
    const delete_ = (x, xs) => {
        const i = xs.indexOf(x);
        return i !== -1 ? (xs.slice(0, i)
            .concat(xs.slice(i, -1))) : xs;
    };

    //  (\\)  :: (Eq a) => [a] -> [a] -> [a]
    const difference = (xs, ys) =>
        ys.reduce((a, x) => filter(z => z !== x, a), xs);

    // filter :: (a -> Bool) -> [a] -> [a]
    const filter = (f, xs) => xs.filter(f);

    // flip :: (a -> b -> c) -> b -> a -> c
    const flip = f => (a, b) => f.apply(null, [b, a]);

    // foldl :: (b -> a -> b) -> b -> [a] -> b
    const foldl = (f, a, xs) => xs.reduce(f, a);

    // nub :: [a] -> [a]
    const nub = xs => {
        const mht = unconsMay(xs);
        return mht.nothing ? xs : (
            ([h, t]) => [h].concat(nub(t.filter(s => s !== h)))
        )(mht.just);
    };

    // show :: a -> String
    const show = x => JSON.stringify(x, null, 2);

    // unconsMay :: [a] -> Maybe (a, [a])
    const unconsMay = xs => xs.length > 0 ? {
        just: [xs[0], xs.slice(1)],
        nothing: false
    } : {
        nothing: true
    };

    // union :: [a] -> [a] -> [a]
    const union = (xs, ys) => {
        const sx = nub(xs);
        return sx.concat(foldl(flip(delete_), nub(ys), sx));
    };

    // TEST -------------------------------------------------------------------
    const
        a = ["John", "Serena", "Bob", "Mary", "Serena"],
        b = ["Jim", "Mary", "John", "Jim", "Bob"];

    return show(
        symmetricDifference(a, b)
    );
})();
