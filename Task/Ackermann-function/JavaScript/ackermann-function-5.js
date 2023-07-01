(() => {
    'use strict';

    // ackermann :: Int -> Int -> Int
    const ackermann = m => n => {
        const go = (m, n) =>
            0 === m ? (
                succ(n)
            ) : go(pred(m), 0 === n ? (
                1
            ) : go(m, pred(n)));
        return go(m, n);
    };

    // TEST -----------------------------------------------
    const main = () => console.log(JSON.stringify(
        [0, 1, 2, 3].map(
            flip(ackermann)(3)
        )
    ));


    // GENERAL FUNCTIONS ----------------------------------

    // flip :: (a -> b -> c) -> b -> a -> c
    const flip = f =>
        x => y => f(y)(x);

    // pred :: Enum a => a -> a
    const pred = x => x - 1;

    // succ :: Enum a => a -> a
    const succ = x => 1 + x;


    // MAIN ---
    return main();
})();
