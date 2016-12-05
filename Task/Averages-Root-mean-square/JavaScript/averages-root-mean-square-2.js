(lst => {
    'use strict';


    // rootMeanSquare :: [Num] -> Real
    let rootMeanSquare = lst =>
        Math.sqrt(
            lst.reduce(
                (a, x) => (a + x * x),
                0
            ) / lst.length
        );


    return rootMeanSquare(lst);


})([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
