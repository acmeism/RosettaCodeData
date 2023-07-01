(() => {
    'use strict';

    // CATALAN

    // catalanSeries :: Int -> [Int]
    let catalanSeries = n => {
        let alternate = xs => xs.reduce(
                (a, x, i) => i % 2 === 0 ? a.concat([x]) : a, []
            ),
            diff = xs => xs.length > 1 ? xs[0] - xs[1] : xs[0];

        return alternate(pascal(n * 2))
            .map((xs, i) => diff(drop(i, xs)));
    }

    // PASCAL

    // pascal :: Int -> [[Int]]
    let pascal = n => until(
            m => m.level <= 1,
            m => {
                let nxt = zipWith(
                    (a, b) => a + b, [0].concat(m.row), m.row.concat(0)
                );
                return {
                    row: nxt,
                    triangle: m.triangle.concat([nxt]),
                    level: m.level - 1
                }
            }, {
                level: n,
                row: [1],
                triangle: [
                    [1]
                ]
            }
        )
        .triangle;


    // GENERIC FUNCTIONS

    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    let zipWith = (f, xs, ys) =>
        xs.length === ys.length ? (
            xs.map((x, i) => f(x, ys[i]))
        ) : undefined;

    // until :: (a -> Bool) -> (a -> a) -> a -> a
    let until = (p, f, x) => {
        let v = x;
        while (!p(v)) v = f(v);
        return v;
    }

    // drop :: Int -> [a] -> [a]
    let drop = (n, xs) => xs.slice(n);

    // tail :: [a] -> [a]
    let tail = xs => xs.length ? xs.slice(1) : undefined;

    return tail(catalanSeries(16));
})();
