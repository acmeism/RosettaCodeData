(() => {
    'use strict';

    // replicate :: Int -> String -> String
    const replicate = (n, s) => {
        let v = [s],
            o = [];
        if (n < 1) return o;
        while (n > 1) {
            if (n & 1) o = o + v;
            n >>= 1;
            v = v + v;
        }
        return o.concat(v);
    };


    return replicate(5000, "ha")
})();
