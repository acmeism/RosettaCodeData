(() => {
    'use strict';

    // isHappy :: Int -> Bool
    function isHappy(n) {
        let f = n => n.toString()
            .split('')
            .reduce((a, x) => a + Math.pow(parseInt(x, 10), 2), 0),
            p = (s, n) => n === 1 ? true : (
                s.has(n) ? false : p(s.add(n), f(n))
            );
        return p(new Set(), n);
    }

    // TEST

    // range :: Int -> Int -> [Int]
    let range = (m, n) => Array.from({
        length: Math.floor(n - m) + 1
    }, (_, i) => m + i);

    return range(1, 50)
        .filter(isHappy)
        .slice(0, 8);
})()
