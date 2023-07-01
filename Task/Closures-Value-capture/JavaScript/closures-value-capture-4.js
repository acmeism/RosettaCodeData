(function () {
    'use strict';

    // Int -> Int -> [Int]
    function range(m, n) {
        return Array.apply(null, Array(n - m + 1))
            .map(function (x, i) {
                return m + i;
            });
    }

    var lstFns = range(0, 10)
        .map(function (i) {
            return function () {
                return i * i;
            };
        })

    return lstFns[3]();

})();
