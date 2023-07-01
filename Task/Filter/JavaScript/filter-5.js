(() => {
    'use strict';

    // isEven :: Int -> Bool
    const isEven = n => n % 2 === 0;


    // TEST

    return [1,2,3,4,5,6,7,8,9]
        .filter(isEven);

    // [2, 4, 6, 8]
})();
