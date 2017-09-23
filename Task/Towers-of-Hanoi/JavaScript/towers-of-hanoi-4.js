(() => {
    'use strict';

    // hanoi :: Int -> String -> String -> String -> [[String, String]]
    const hanoi = (n, a, b, c) =>
        n ? hanoi(n - 1, a, c, b)
        .concat([
            [a, b]
        ])
        .concat(hanoi(n - 1, c, b, a)) : [];

    // show :: a -> String
    const show = x => JSON.stringify(x, null, 2);

    return show(
        hanoi(3, 'left', 'right', 'mid')
        .map(d => d[0] + ' -> ' + d[1])
    );
})();
