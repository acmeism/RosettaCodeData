(() => {
    'use strict';

    // dotProduct :: [a] -> [a] -> Either String a
    const dotProduct = xs =>
        // Dot product of two vectors of equal dimension.
        ys => xs.length !== ys.length ? (
            Left('Dot product not defined - vectors differ in dimension.')
        ) : Right(sum(
            zipWith(mul)(Array.from(xs))(Array.from(ys))
        ));

    // crossProduct :: Num a => (a, a, a) -> (a, a, a)
    // Either String -> (a, a, a)
    const crossProduct = xs =>
        // Cross product of two 3D vectors.
        ys => 3 !== xs.length || 3 !== ys.length ? (
            Left('crossProduct is defined only for 3d vectors.')
        ) : Right((() => {
            const [x1, x2, x3] = Array.from(xs);
            const [y1, y2, y3] = Array.from(ys);
            return [
                x2 * y3 - x3 * y2,
                x3 * y1 - x1 * y3,
                x1 * y2 - x2 * y1
            ];
        })());

    // scalarTriple :: Num a => (a, a, a) -> (a, a, a) -> (a, a a) ->
    // Either String -> a
    const scalarTriple = q =>
        // The scalar triple product.
        r => s => bindLR(crossProduct(r)(s))(
            dotProduct(q)
        );

    // vectorTriple :: Num a => (a, a, a) -> (a, a, a) -> (a, a a) ->
    // Either String -> (a, a, a)
    const vectorTriple = q =>
        // The vector triple product.
        r => s => bindLR(crossProduct(r)(s))(
            crossProduct(q)
        );

    // main :: IO ()
    const main = () => {
        // TEST -------------------------------------------
        const
            a = [3, 4, 5],
            b = [4, 3, 5],
            c = [-5, -12, -13],
            d = [3, 4, 5, 6];

        console.log(unlines(
            zipWith(k => f => k + show(
                saturated(f)([a, b, c])
            ))(['a . b', 'a x b', 'a . (b x c)', 'a x (b x c)'])(
                [dotProduct, crossProduct, scalarTriple, vectorTriple]
            )
            .concat([
                'a . d' + show(
                    dotProduct(a)(d)
                ),
                'a . (b x d)' + show(
                    scalarTriple(a)(b)(d)
                )
            ])
        ));
    };


    // GENERIC FUNCTIONS ----------------------------------

    // Left :: a -> Either a b
    const Left = x => ({
        type: 'Either',
        Left: x
    });

    // Right :: b -> Either a b
    const Right = x => ({
        type: 'Either',
        Right: x
    });

    // bindLR (>>=) :: Either a -> (a -> Either b) -> Either b
    const bindLR = m => mf =>
        undefined !== m.Left ? (
            m
        ) : mf(m.Right);

    // either :: (a -> c) -> (b -> c) -> Either a b -> c
    const either = fl => fr => e =>
        'Either' === e.type ? (
            undefined !== e.Left ? (
                fl(e.Left)
            ) : fr(e.Right)
        ) : undefined;

    // identity :: a -> a
    const identity = x => x;

    // mul (*) :: Num a => a -> a -> a
    const mul = a => b => a * b;

    // Curried function -> [Argument] -> a more saturated value
    const saturated = f =>
        // A curried function applied successively to
        // a list of arguments up to, but not beyond,
        // the point of saturation.
        args => 0 < args.length ? (
            args.slice(1).reduce(
                (a, x) => 'function' !== typeof a ? (
                    a
                ) : a(x),
                f(args[0])
            )
        ) : f;

    // show :: Either String a -> String
    const show = x =>
        either(x => ' => ' + x)(
            x => ' = ' + JSON.stringify(x)
        )(x);

    // sum :: [Num] -> Num
    const sum = xs => xs.reduce((a, x) => a + x, 0);

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // zipWith:: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = f => xs => ys =>
        xs.slice(
            0, Math.min(xs.length, ys.length)
        ).map((x, i) => f(x)(ys[i]));

    // MAIN ---
    return main();
})();
