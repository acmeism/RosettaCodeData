(function () {
    'use strict';

    // disjointSort :: [a] -> [Int] -> [a]
    function disjointSort(xs, indices) {

        // Sequence of indices discarded
        var indicesSorted = indices.sort(),
            subsetSorted = indicesSorted
            .map(function (i) {
                return xs[i];
            })
            .sort();

        return xs
            .map(function (x, i) {
                var iIndex = indicesSorted.indexOf(i);

                return iIndex !== -1 ? (
                    subsetSorted[iIndex]
                ) : x;
            });
    }

    return disjointSort([7, 6, 5, 4, 3, 2, 1, 0], [6, 1, 7])

})();
