(() => {
    'use strict';


    // compose :: [(a -> a)] -> (a -> a)
    let compose = fs => x => fs.reduceRight((a, f) => f(a), x);


    // TEST a composition of 3 functions (right to left)

    let sqrt = Math.sqrt,

        succ = x => x + 1,

        half = x => x / 2;


    return compose([half, succ, sqrt])(5);

    // --> 1.618033988749895
})();
