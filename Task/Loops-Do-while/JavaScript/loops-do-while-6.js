(() => {
    'use strict';

    // unfoldr :: (b -> Maybe (a, b)) -> b -> [a]
    function unfoldr(mf, v) {
        for (var lst = [], a = v, m;
            (m = mf(a)) && m.valid;) {
            lst.push(m.value), a = m.new;
        }
        return lst;
    }

    // until :: (a -> Bool) -> (a -> a) -> a -> a
    function until(p, f, x) {
        let v = x;
        while(!p(v)) v = f(v);
        return v;
    }

    let result1 = unfoldr(
        x => {
            return {
                value: x,
                valid: (x % 6) !== 0,
                new: x + 1
            }
        },
        1
    );

    let result2 = until(
        m => (m.n % 6) === 0,
        m => {
            return {
                n : m.n + 1,
                xs : m.xs.concat(m.n)
            };
        },
        {
            n: 1,
            xs: []
        }
    ).xs;

    return [result1, result2];
})();
