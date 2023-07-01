(() => {
    "use strict";

    // -------------- MULTIPLE COMPOSITION ---------------

    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (...fs) =>
        // A function defined by the right-to-left
        // composition of all the functions in fs.
        fs.reduce(
            (f, g) => x => f(g(x)),
            x => x
        );

    // ---------------------- TEST -----------------------
    const
        sqrt = Math.sqrt,
        succ = x => x + 1,
        half = x => x / 2;

    return compose(half, succ, sqrt)(5);

    // --> 1.618033988749895
})();
