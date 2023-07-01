(() => {
    "use strict";

    // wakeSplit :: Int -> Int -> Int -> Int
    const wakeSplit = intSailors =>
        (intNuts, intDepth) => {
            const
                nDepth = intDepth !== undefined ? (
                    intDepth
                ) : intSailors,
                portion = Math.floor(intNuts / intSailors),
                remain = intNuts % intSailors;

            return 0 >= portion || remain !== (
                nDepth ? (
                    1
                ) : 0
            ) ? (
                null
            ) : nDepth ? (
                wakeSplit(
                    intSailors
                )(
                    intNuts - portion - remain,
                    nDepth - 1
                )
            ) : intNuts;
        };

    // ---------------------- TEST -----------------------
    const main = () =>
        // TEST for 5, 6, and 7 Sailors
        [5, 6, 7].map(intSailors => {
            const intNuts = intSailors;

            return until(
                wakeSplit(intNuts)
            )(x => 1 + x)(intNuts);
        });


    // --------------------- GENERIC ---------------------

    // until :: (a -> Bool) -> (a -> a) -> a -> a
    const until = p =>
        // The value resulting from repeated applications
        // of f to the seed value x, terminating when
        // that result returns true for the predicate p.
        f => x => {
            let v = x;

            while (!p(v)) {
                v = f(v);
            }

            return v;
        };

    // MAIN ---
    return main();
})();
