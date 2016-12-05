(function () {
    'use strict';

    // quickSort :: (Ord a) => [a] -> [a]
    function quickSort(xs) {

        if (xs.length) {
            var h = xs[0],
                t = xs.slice(1),

                lessMore = partition(function (x) {
                    return x <= h;
                }, t),
                less = lessMore[0],
                more = lessMore[1];

            return [].concat.apply(
                [], [quickSort(less), h, quickSort(more)]
            );

        } else return [];
    }


    // partition :: Predicate -> List -> (Matches, nonMatches)
    // partition :: (a -> Bool) -> [a] -> ([a], [a])
    function partition(p, xs) {
        return xs.reduce(function (a, x) {
            return (
                a[p(x) ? 0 : 1].push(x),
                a
            );
        }, [[], []]);
    }

    return quickSort([11.8, 14.1, 21.3, 8.5, 16.7, 5.7])

})();
