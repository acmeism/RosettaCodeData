(() => {
    'use strict';

    // zeckendorf :: Int -> String
    function zeckendorf(n) {
        let f = (n, x) => (n < x ? [n, 0] : [n - x, 1]);

        return (n === 0 ? (
                [0]
            ) : mapAccumL(f, n, reverse(tail(fibUntil(n))))[1])
            .join('');
    }


    // fibUntil :: Int -> [Int]
    let fibUntil = n => {
        let xs = [];
        until(
            ([a, b]) => a > n,
            ([a, b]) => (xs.push(a), [b, a + b]), [1, 1]
        )
        return xs;
    }

    // GENERIC FUNCTIONS

    // mapAccumL :: (acc -> x -> (acc, y)) -> acc -> [x] -> (acc, [y])
    let mapAccumL = (f, acc, xs) => {
        return xs.reduce((a, x) => {
            let pair = f(a[0], x);

            return [pair[0], a[1].concat(pair[1])];
        }, [acc, []]);
    }

    // until :: (a -> Bool) -> (a -> a) -> a -> a
    let until = (p, f, x) => {
        let v = x;
        while (!p(v)) v = f(v);
        return v;
    }

    // tail :: [a] -> [a]
    let tail = xs => xs.length ? xs.slice(1) : undefined;

    // reverse :: [a] -> [a]
    let reverse = xs => xs.slice(0)
        .reverse();

    // range :: Int -> Int -> [Int]
    let range = (m, n) =>
        Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i);

    // TEST
    return range(0, 20)
        .map(zeckendorf)
        .join('\n')

})();
