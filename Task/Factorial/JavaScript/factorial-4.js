(function () {
    'use strict';

    // factorial :: Int -> Int
    function factorial(x) {

        return range(1, x)
            .reduce(function (a, b) {
                return a * b;
            }, 1);
    }



    // range :: Int -> Int -> [Int]
    function range(m, n) {
        var a = Array(n - m + 1),
            i = n + 1;

        while (i-- > m) a[i - m] = i;
        return a;
    }


    return factorial(18);

})();
