(() => {
    'use strict';

    // isHappy :: Int -> Bool
    let isHappy = n => {
        let f = n => n.toString()
            .split('')
            .reduce((a, x) => a + Math.pow(parseInt(x, 10), 2), 0),
            p = (s, n) => n === 1 ? true : (
                s.has(n) ? false : p(s.add(n), f(n))
            );
        return p(new Set(), n);
    },

    // until :: (a -> Bool) -> (a -> a) -> a -> a
    until = (p, f, x) => {
        let v = x;
        while (!p(v)) v = f(v);
        return v;
    };

    return until(
        m => m.xs.length === 8,
        m => {
            let n = m.n;
            return {
                n: n + 1,
                xs: isHappy(n) ? m.xs.concat(n) : m.xs
            };
        }, {
            n: 1,
            xs: []
        }
    ).xs;
})();
