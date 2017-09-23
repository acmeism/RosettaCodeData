(() => {
    'use strict';

    // compose :: (a -> b) -> (b -> c) -> (a -> c)
    const compose = (f, g) => x => g(f(x));


    // TEST
    const
        sqrt = Math.sqrt,
        succ = x => x + 1,
        half = x => x / 2;

    const
        succSqrt = compose(sqrt, succ),
        halfSuccSqrt = compose(succSqrt, half);

    return halfSuccSqrt(5);
})();
