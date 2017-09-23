(function () {
    'use strict';

    // GENERIC FUNCTIONS FOR COMPARISONS

    // Ordering :: ( LT | EQ | GT ) | ( -1 | 0 | 1 )

    // compare :: a -> a -> Ordering
    var compare = function (a, b) {
        return a < b ? -1 : a > b ? 1 : 0;
    };

    // mappendOrdering :: Ordering -> Ordering -> Ordering
    var mappendOrdering = function (a, b) {
        return a !== 0 ? a : b;
    };

    // on :: (b -> b -> c) -> (a -> b) -> a -> a -> c
    var on = function (f, g) {
        return function (a, b) {
            return f(g(a), g(b));
        };
    };

    // flip :: (a -> b -> c) -> b -> a -> c
    var flip = function (f) {
        return function (a, b) {
            return f.apply(null, [b, a]);
        };
    };

    // arrayCopy :: [a] -> [a]
    var arrayCopy = function (xs) {
        return xs.slice(0);
    };

    // show :: a -> String
    var show = function (x) {
        return JSON.stringify(x, null, 2);
    };

    // TEST
    var xs = ['Shanghai', 'Karachi', 'Beijing', 'Sao Paulo', 'Dhaka', 'Delhi', 'Lagos'];

    var rs = [{
        name: 'Shanghai',
        pop: 24.2
    }, {
        name: 'Karachi',
        pop: 23.5
    }, {
        name: 'Beijing',
        pop: 21.5
    }, {
        name: 'Sao Paulo',
        pop: 24.2
    }, {
        name: 'Dhaka',
        pop: 17.0
    }, {
        name: 'Delhi',
        pop: 16.8
    }, {
        name: 'Lagos',
        pop: 16.1
    }];

    // population :: Dictionary -> Num
    var population = function (x) {
        return x.pop;
    };

    // length :: [a] -> Int
    var length = function (xs) {
        return xs.length;
    };

    // toLower :: String -> String
    var toLower = function (s) {
        return s.toLowerCase();
    };

    // lengthThenAZ :: String -> String -> ( -1 | 0 | 1)
    var lengthThenAZ = function (a, b) {
        return mappendOrdering(
            on(compare, length)(a, b),
            on(compare, toLower)(a, b)
        );
    };

    // descLengthThenAZ :: String -> String -> ( -1 | 0 | 1)
    var descLengthThenAZ = function (a, b) {
        return mappendOrdering(
            on(flip(compare), length)(a, b),
            on(compare, toLower)(a, b)
        );
    };

    return show({
        default: arrayCopy(xs)
            .sort(compare),

        descendingDefault: arrayCopy(xs)
            .sort(flip(compare)),

        byLengthThenAZ: arrayCopy(xs)
            .sort(lengthThenAZ),

        byDescendingLengthThenZA: arrayCopy(xs)
            .sort(flip(lengthThenAZ)),

        byDescendingLengthThenAZ: arrayCopy(xs)
            .sort(descLengthThenAZ),

        byPopulation: arrayCopy(rs)
            .sort(on(compare, population)),

        byDescendingPopulation: arrayCopy(rs)
            .sort(on(flip(compare), population))
    });
})();
