(function () {
    'use strict';

    // waterCollected :: [Int] -> Int
    var waterCollected = function (xs) {
        return sum(                   // water above each bar
            zipWith(function (a, b) {
                    return a - b;     // difference between water level and bar
                },
                zipWith(min,          // lower of two flanking walls
                    scanl1(max, xs),  // highest walls to left
                    scanr1(max, xs)   // highest walls to right
                ),
                xs                    // tops of bars
            )
            .filter(function (x) {
                return x > 0;         // only bars with water above them
            })
        );
    };

    // GENERIC FUNCTIONS ----------------------------------------

    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    var zipWith = function (f, xs, ys) {
        var ny = ys.length;
        return (xs.length <= ny ? xs : xs.slice(0, ny))
            .map(function (x, i) {
                return f(x, ys[i]);
            });
    };

    // scanl1 is a variant of scanl that has no starting value argument
    // scanl1 :: (a -> a -> a) -> [a] -> [a]
    var scanl1 = function (f, xs) {
        return xs.length > 0 ? scanl(f, xs[0], xs.slice(1)) : [];
    };

    // scanr1 is a variant of scanr that has no starting value argument
    // scanr1 :: (a -> a -> a) -> [a] -> [a]
    var scanr1 = function (f, xs) {
        return xs.length > 0 ? scanr(f, xs.slice(-1)[0], xs.slice(0, -1)) : [];
    };

    // scanl :: (b -> a -> b) -> b -> [a] -> [b]
    var scanl = function (f, startValue, xs) {
        var lst = [startValue];
        return xs.reduce(function (a, x) {
            var v = f(a, x);
            return lst.push(v), v;
        }, startValue), lst;
    };

    // scanr :: (b -> a -> b) -> b -> [a] -> [b]
    var scanr = function (f, startValue, xs) {
        var lst = [startValue];
        return xs.reduceRight(function (a, x) {
            var v = f(a, x);
            return lst.push(v), v;
        }, startValue), lst.reverse();
    };

    // sum :: (Num a) => [a] -> a
    var sum = function (xs) {
        return xs.reduce(function (a, x) {
            return a + x;
        }, 0);
    };

    // max :: Ord a => a -> a -> a
    var max = function (a, b) {
        return a > b ? a : b;
    };

    // min :: Ord a => a -> a -> a
    var min = function (a, b) {
        return b < a ? b : a;
    };

    // TEST ---------------------------------------------------
    return [
        [1, 5, 3, 7, 2],
        [5, 3, 7, 2, 6, 4, 5, 9, 1, 2],
        [2, 6, 3, 5, 2, 8, 1, 4, 2, 2, 5, 3, 5, 7, 4, 1],
        [5, 5, 5, 5],
        [5, 6, 7, 8],
        [8, 7, 7, 6],
        [6, 7, 10, 7, 6]
    ].map(waterCollected);

    //--> [2, 14, 35, 0, 0, 0, 0]
})();
