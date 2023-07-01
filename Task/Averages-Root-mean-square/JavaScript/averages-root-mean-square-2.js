(() => {
    'use strict';


    // rootMeanSquare :: [Num] -> Real
    const rootMeanSquare = xs =>
       Math.sqrt(
            xs.reduce(
                (a, x) => (a + x * x),
                0
           ) / xs.length
        );


    return rootMeanSquare([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);

     // -> 6.2048368229954285
})();
