(() => {
    'use strict';

    // QUICKSORT --------------------------------------------------------------

    // quickSort :: (Ord a) => [a] -> [a]
    const quickSort = xs =>
        xs.length > 1 ? (() => {
            const
                h = xs[0],
                [less, more] = partition(x => x <= h, xs.slice(1));
            return [].concat.apply(
                [], [quickSort(less), h, quickSort(more)]
            );
        })() : xs;


    // GENERIC ----------------------------------------------------------------

    // partition :: Predicate -> List -> (Matches, nonMatches)
    // partition :: (a -> Bool) -> [a] -> ([a], [a])
    const partition = (p, xs) =>
        xs.reduce((a, x) =>
            p(x) ? [a[0].concat(x), a[1]] : [a[0], a[1].concat(x)], [
                [],
                []
            ]);

    // TEST -------------------------------------------------------------------
    return quickSort([11.8, 14.1, 21.3, 8.5, 16.7, 5.7]);
})();
