(function (xs) {
    'use strict';

    // foldl :: (b -> a -> b) -> b -> [a] -> b
    function foldl(f, acc, xs) {
        return xs.reduce(f, acc);
    }

    // foldr :: (b -> a -> b) -> b -> [a] -> b
    function foldr(f, acc, xs) {
        return xs.reduceRight(f, acc);
    }

    // Test folds in both directions
    return [foldl, foldr].map(function (f) {
        return f(function (acc, x) {
            return acc + (x * 2).toString() + ' ';
        }, [], xs);
    });

})([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]);
