(function () {
    'use strict';

    // nub :: [a] -> [a]
    function nub(xs) {

        // Eq :: a -> a -> Bool
        function Eq(a, b) {
            return a === b;
        }

        // nubBy :: (a -> a -> Bool) -> [a] -> [a]
        function nubBy(fnEq, xs) {
            var x = xs.length ? xs[0] : undefined;

            return x !== undefined ? [x].concat(
                nubBy(fnEq, xs.slice(1)
                    .filter(function (y) {
                        return !fnEq(x, y);
                    }))
            ) : [];
        }

        return nubBy(Eq, xs);
    }


    // TEST

    return [
        nub('4 3 2 8 0 1 9 5 1 7 6 3 9 9 4 2 1 5 3 2'.split(' '))
        .map(function (x) {
            return Number(x);
        }),
        nub('chthonic eleemosynary paronomasiac'.split(''))
        .join('')
    ]

})();
