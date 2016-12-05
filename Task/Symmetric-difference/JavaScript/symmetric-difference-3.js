((a, b) => {
    'use strict';


    let // UNION AND DIFFERENCE

    // union :: [a] -> [a] -> [a]
        union = (xs, ys) => unionBy((a, b) => a === b, xs, ys),

        // difference :: [a] -> [a] -> [a]
        difference = (xs, ys) =>
            ys.reduce((a, y) =>
                a.indexOf(y) !== -1 ? (
                    delete_(y, a)
                ) : a.concat(y), xs),



        // GENERAL PRIMITIVES

        // unionBy :: (a -> a -> Bool) -> [a] -> [a] -> [a]
        unionBy = (f, xs, ys) => {
            let sx = nubBy(f, xs),
                sy = nubBy(f, ys);

            return sx.concat(
                sx
                .reduce(
                    (a, x) => deleteBy(f, x, a),
                    sy
                )
            )
        },

        // deleteBy :: (a -> a -> Bool) -> a -> [a] -> [a]
        deleteBy = (f, x, xs) =>
            xs.reduce((a, y) => f(x, y) ? a : a.concat(y), []),

        // delete_  :: a -> [a] -> [a]
        delete_ = (x, xs) =>
            deleteBy((a, b) => a === b, x, xs),

        // nubBy :: (a -> a -> Bool) -> [a] -> [a]
        nubBy = (f, xs) => {
            let x = (xs.length ? xs[0] : undefined);

            return x !== undefined ? [x].concat(
                nubBy(f, xs.slice(1)
                    .filter(y => !f(x, y))
                )
            ) : [];
        };



    // 'SYMMETRIC DIFFERENCE'

    return union(
        difference(a, b),
        difference(b, a)
    );

})(
    ["John", "Serena", "Bob", "Mary", "Serena"],
    ["Jim", "Mary", "John", "Jim", "Bob"]
);
