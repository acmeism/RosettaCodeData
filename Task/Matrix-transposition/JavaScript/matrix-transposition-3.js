(() => {
    'use strict';

    // transpose :: [[a]] -> [[a]]
    const transpose = xs =>
        xs[0].map((_, iCol) => xs.map((row) => row[iCol]));

    // TEST
    return transpose([
        [1, 2],
        [3, 4],
        [5, 6]
    ]);
})();
