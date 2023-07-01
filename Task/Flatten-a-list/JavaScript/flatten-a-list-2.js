(function () {
    'use strict';

    // flatten :: Tree a -> [a]
    function flatten(t) {
        return (t instanceof Array ? concatMap(flatten, t) : t);
    }

    // concatMap :: (a -> [b]) -> [a] -> [b]
    function concatMap(f, xs) {
        return [].concat.apply([], xs.map(f));
    }

    return flatten(
        [[1], 2, [[3, 4], 5], [[[]]], [[[6]]], 7, 8, []]
    );

})();
