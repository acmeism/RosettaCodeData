(() => {
    "use strict";

    // --------------- RODRIGUES ROTATION ----------------

    const rodrigues = v1 =>
        v2 => aRotate(v1)(
            normalize(
                crossProduct(v1)(v2)
            )
        )(
            angle(v1)(v2)
        );

    // ---------------------- TEST -----------------------
    const main = () =>
        rodrigues([5, -6, 4])([8, 5, -30]);


    // ---------------- VECTOR FUNCTIONS -----------------
    const aRotate = p =>
        v => a => {
            const
                cosa = Math.cos(a),
                sina = Math.sin(a),
                t = 1 - cosa,
                [x, y, z] = v;

            return matrixMultiply([
                [
                    cosa + ((x ** 2) * t),
                    (x * y * t) - (z * sina),
                    (x * z * t) + (y * sina)
                ],
                [
                    (x * y * t) + (z * sina),
                    cosa + ((y ** 2) * t),
                    (y * z * t) - (x * sina)
                ],
                [
                    (z * x * t) - (y * sina),
                    (z * y * t) + (x * sina),
                    cosa + (z * z * t)
                ]
            ])(p);
        };


    const angle = v1 =>
        v2 => Math.acos(
            dotProduct(v1)(v2) / (
                norm(v1) * norm(v2)
            )
        );


    const crossProduct = xs =>
        // Cross product of two 3D vectors.
        ys => {
            const [x1, x2, x3] = xs;
            const [y1, y2, y3] = ys;

            return [
                (x2 * y3) - (x3 * y2),
                (x3 * y1) - (x1 * y3),
                (x1 * y2) - (x2 * y1)
            ];
        };


    const dotProduct = xs =>
        compose(
            sum,
            zipWith(a => b => a * b)(xs)
        );


    const matrixMultiply = matrix =>
        compose(
            flip(map)(matrix),
            dotProduct
        );


    const norm = v =>
        Math.sqrt(
            v.reduce((a, x) => a + (x ** 2), 0)
        );


    const normalize = v => {
        const len = norm(v);

        return v.map(x => x / len);
    };


    // --------------------- GENERIC ---------------------

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
        x => y => op(y)(x);


    // map :: (a -> b) -> [a] -> [b]
    const map = f =>
        // The list obtained by applying f
        // to each element of xs.
        // (The image of xs under f).
        xs => [...xs].map(f);


    // sum :: [Num] -> Num
    const sum = xs =>
        // The numeric sum of all values in xs.
        xs.reduce((a, x) => a + x, 0);


    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = f =>
        // A list constructed by zipping with a
        // custom function, rather than with the
        // default tuple constructor.
        xs => ys => xs.map(
            (x, i) => f(x)(ys[i])
        ).slice(
            0, Math.min(xs.length, ys.length)
        );


    return JSON.stringify(
        main(),
        null, 2
    );
})();
