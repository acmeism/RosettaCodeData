(function (n) {
    'use strict';


    // finalDoors :: Int -> [(Int, Bool)]
    function finalDoors(n) {
        var lstRange = range(1, n);

        return lstRange
            .reduce(function (a, _, k) {
                var m = k + 1;

                return a.map(function (x, i) {
                    var j = i + 1;

                    return [j, j % m ? x[1] : !x[1]];
                });
            }, zip(
                lstRange,
                replicate(n, false)
            ));
    };



    // GENERIC FUNCTIONS

    // zip :: [a] -> [b] -> [(a,b)]
    function zip(xs, ys) {
        return xs.length === ys.length ? (
            xs.map(function (x, i) {
                return [x, ys[i]];
            })
        ) : undefined;
    }

    // replicate :: Int -> a -> [a]
    function replicate(n, a) {
        var v = [a],
            o = [];

        if (n < 1) return o;
        while (n > 1) {
            if (n & 1) o = o.concat(v);
            n >>= 1;
            v = v.concat(v);
        }
        return o.concat(v);
    }

    // range(intFrom, intTo, optional intStep)
    // Int -> Int -> Maybe Int -> [Int]
    function range(m, n, delta) {
        var d = delta || 1,
            blnUp = n > m,
            lng = Math.floor((blnUp ? n - m : m - n) / d) + 1,
            a = Array(lng),
            i = lng;

        if (blnUp)
            while (i--) a[i] = (d * i) + m;
        else
            while (i--) a[i] = m - (d * i);

        return a;
    }


    return finalDoors(n)
        .filter(function (tuple) {
            return tuple[1];
        })
        .map(function (tuple) {
            return {
                door: tuple[0],
                open: tuple[1]
            };
        });

})(100);
