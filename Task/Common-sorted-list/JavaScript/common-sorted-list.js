(() => {
    "use strict";

    // --------------- COMMON SORTED LIST ----------------

    // commonSorted :: Ord a => [[a]] -> [a]
    const commonSorted = xs =>
        sort(nub(concat(xs)));


    // ---------------------- TEST -----------------------
    const main = () =>
        commonSorted([
            [5, 1, 3, 8, 9, 4, 8, 7],
            [3, 5, 9, 8, 4],
            [1, 3, 7, 9]
        ]);


    // --------------------- GENERIC ---------------------

    // concat :: [[a]] -> [a]
    const concat = xs =>
        xs.flat(1);


    // nub :: Eq a => [a] -> [a]
    const nub = xs => [...new Set(xs)];


    // sort :: Ord a => [a] -> [a]
    const sort = xs =>
        // An (ascending) sorted copy of xs.
        xs.slice().sort();

    return main();
})();
