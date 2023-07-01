(function () {
    'use strict';

    // flatten :: Tree a -> [a]
    function flatten(a) {
        return a instanceof Array ? [].concat.apply([], a.map(flatten)) : a;
    }

    return flatten(
        [[1], 2, [[3, 4], 5], [[[]]], [[[6]]], 7, 8, []]
    );

})();
