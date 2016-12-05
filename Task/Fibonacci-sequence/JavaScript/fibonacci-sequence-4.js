(function () {
    'use strict';

    function fib(n) {
        return Array.apply(null, Array(n + 1))
            .map(function (_, i, lst) {
                return lst[i] = (
                    i ? i < 2 ? 1 :
                    lst[i - 2] + lst[i - 1] :
                    0
                );
            })[n];
    }

    return fib(32);

})();
