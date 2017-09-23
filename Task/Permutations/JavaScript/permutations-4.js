(function () {
    'use strict';

    // permutations :: [a] -> [[a]]
    var permutations = function (xs) {
        return xs.length ? concatMap(function (x) {
            return concatMap(function (ys) {
                return [[x].concat(ys)];
            }, permutations(delete_(x, xs)));
        }, xs) : [[]];
    };

    // GENERIC FUNCTIONS

    // concatMap :: (a -> [b]) -> [a] -> [b]
    var concatMap = function (f, xs) {
        return [].concat.apply([], xs.map(f));
    };

    // delete :: Eq a => a -> [a] -> [a]
    var delete_ = function (x, xs) {
        return deleteBy(function (a, b) {
            return a === b;
        }, x, xs);
    };

    // deleteBy :: (a -> a -> Bool) -> a -> [a] -> [a]
    var deleteBy = function (f, x, xs) {
        return xs.length > 0 ? f(x, xs[0]) ? xs.slice(1) :
        [xs[0]].concat(deleteBy(f, x, xs.slice(1))) : [];
    };

    // TEST
    return permutations(['Aardvarks', 'eat', 'ants']);
})();
