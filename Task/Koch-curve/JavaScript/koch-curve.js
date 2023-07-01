(() => {
    'use strict';

    // kochSnowflake :: Int -> (Float, Float) -> (Float, Float)
    //                      -> [(Float, Float)]
    const kochSnowflake = n => a => b => {
        // List of points on a Koch snowflake of order n, derived
        // from an equilateral triangle with base a b.
        const points = [a, equilateralApex(a)(b), b];
        return concat(
            zipWith(kochCurve(n))(points)(
                points.slice(1).concat([points[0]])
            )
        );
    };


    // koch :: Int -> (Float, Float) -> (Float, Float)
    //             -> [(Float, Float)]
    const kochCurve = n => ab => xy => {
        // A Koch curve of order N, starting at the point
        // (a, b), and ending at the point (x, y).
        const go = n => ([ab, xy]) =>
            0 !== n ? (() => {
                const [mp, mq] = midThirdOfLine(ab)(xy);
                const points = [
                    ab,
                    mp,
                    equilateralApex(mp)(mq),
                    mq,
                    xy
                ];
                return zip(points)(points.slice(1))
                    .flatMap(go(n - 1))
            })() : [xy];
        return [ab].concat(go(n)([ab, xy]));
    };


    // equilateralApex :: (Float, Float) -> (Float, Float) -> (Float, Float)
    const equilateralApex = p => q =>
        rotatedPoint(Math.PI / 3)(p)(q);


    // rotatedPoint :: Float -> (Float, Float) ->
    //        (Float, Float) -> (Float, Float)
    const rotatedPoint = theta => ([ox, oy]) => ([a, b]) => {
        // The point ab rotated theta radians
        // around the origin xy.
        const [dx, dy] = rotatedVector(theta)(
            [a - ox, oy - b]
        );
        return [ox + dx, oy - dy];
    };


    // rotatedVector :: Float -> (Float, Float) -> (Float, Float)
    const rotatedVector = theta => ([x, y]) =>
        // The vector xy rotated by theta radians.
        [
            x * Math.cos(theta) - y * Math.sin(theta),
            x * Math.sin(theta) + y * Math.cos(theta)
        ];


    // midThirdOfLine :: (Float, Float) -> (Float, Float)
    //                 -> ((Float, Float), (Float, Float))
    const midThirdOfLine = ab => xy => {
        // Second of three equal segments of
        // the line between ab and xy.
        const
            vector = zipWith(dx => x => (dx - x) / 3)(xy)(ab),
            f = zipWith(add)(vector),
            p = f(ab);
        return [p, f(p)];
    };


    // TEST -----------------------------------------------
    // main :: IO ()
    const main = () =>
        // SVG showing a Koch snowflake of order 4.
        console.log(
            svgFromPoints(1024)(
                kochSnowflake(5)(
                    [200, 600]
                )([800, 600])
            )
        );

    // SVG ----------------------------------------------

    // svgFromPoints :: Int -> [(Int, Int)] -> String
    const svgFromPoints = w => ps => [
        '<svg xmlns="http://www.w3.org/2000/svg"',
        `width="500" height="500" viewBox="5 5 ${w} ${w}">`,
        `<path d="M${
        ps.flatMap(p => p.map(n => n.toFixed(2))).join(' ')
    }" `,
        'stroke-width="2" stroke="red" fill="transparent"/>',
        '</svg>'
    ].join('\n');


    // GENERIC --------------------------------------------

    // add :: Num -> Num -> Num
    const add = a => b => a + b;

    // concat :: [[a]] -> [a]
    const concat = xs => [].concat.apply([], xs);

    // zip :: [a] -> [b] -> [(a, b)]
    const zip = xs => ys =>
        xs.slice(
            0, Math.min(xs.length, ys.length)
        ).map((x, i) => [x, ys[i]]);


    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = f => xs => ys =>
        xs.slice(
            0, Math.min(xs.length, ys.length)
        ).map((x, i) => f(x)(ys[i]));

    // MAIN ---
    return main();
})();
