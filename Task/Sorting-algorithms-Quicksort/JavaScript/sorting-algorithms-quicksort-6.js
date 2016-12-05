(function () {
    'use strict';

    // quickSort :: (Ord a) => [a] -> [a]
    function quickSort(xs) {

        if (xs.length) {
            var h = xs[0],
                [less, more] = partition(
                    x => x <= h,
                    xs.slice(1)
                );

            return [].concat.apply(
                [], [quickSort(less), h, quickSort(more)]
            );

        } else return [];
    }


    // partition :: Predicate -> List -> (Matches, nonMatches)
    // partition :: (a -> Bool) -> [a] -> ([a], [a])
    function partition(p, xs) {
        return xs.reduce((a, x) => (
                a[p(x) ? 0 : 1].push(x),
                a
            ), [[], []]);
    }

    return quickSort([11.8, 14.1, 21.3, 8.5, 16.7, 5.7]);

})();
