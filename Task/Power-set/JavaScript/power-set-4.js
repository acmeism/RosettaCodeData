(() => {
    'use strict';

    // powerset :: [a] -> [[a]]
    const powerset = xs =>
        xs.reduceRight((a, x) => [...a, ...a.map(y => [x, ...y])], [
            []
        ]);


    // TEST
    return {
        '[1,2,3] ->': powerset([1, 2, 3]),
        'empty set ->': powerset([]),
        'set which contains only the empty set ->': powerset([
            []
        ])
    };
})()
