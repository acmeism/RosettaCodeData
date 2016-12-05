(() => {
    'use strict';

    // <= is already defined for lists in JS

    // compare :: [a] -> [a] -> Bool
    const compare = (xs, ys) => xs <= ys;


    // TEST
    return [
        compare([1, 2, 1, 3, 2], [1, 2, 0, 4, 4, 0, 0, 0]),
        compare([1, 2, 0, 4, 4, 0, 0, 0], [1, 2, 1, 3, 2])
    ];

    // --> [false, true]
})()
