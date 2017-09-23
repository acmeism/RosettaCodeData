(() => {
    'use strict';

    // disjointSort :: [a] -> [Int] -> [a]
    const disjointSort = (xs, indices) => {

        // Sequence of indices discarded
        const indicesSorted = indices.sort(),
            subsetSorted = indicesSorted
            .map(i => xs[i])
            .sort();

        return xs
            .map((x, i) => {
                const iIndex = indicesSorted.indexOf(i);
                return iIndex !== -1 ? (
                    subsetSorted[iIndex]
                ) : x;
            });
    };

    return disjointSort([7, 6, 5, 4, 3, 2, 1, 0], [6, 1, 7]);
})();
