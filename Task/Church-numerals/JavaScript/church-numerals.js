(() => {
    'use strict';

    // ----------------- CHURCH NUMERALS -----------------

    const churchZero = f =>
        identity;


    const churchSucc = n =>
        f => compose(f)(n(f));


    const churchAdd = m =>
        n => f => compose(n(f))(m(f));


    const churchMult = m =>
        n => f => n(m(f));


    const churchExp = m =>
        n => n(m);


    const intFromChurch = n =>
        n(succ)(0);


    const churchFromInt = n =>
        compose(
            foldl(compose)(identity)
        )(
            replicate(n)
        );


    // Or, by explicit recursion:
    const churchFromInt_ = x => {
        const go = i =>
            0 === i ? (
                churchZero
            ) : churchSucc(go(pred(i)));
        return go(x);
    };


    // ---------------------- TEST -----------------------
    // main :: IO ()
    const main = () => {
        const [cThree, cFour] = map(churchFromInt)([3, 4]);

        return map(intFromChurch)([
            churchAdd(cThree)(cFour),
            churchMult(cThree)(cFour),
            churchExp(cFour)(cThree),
            churchExp(cThree)(cFour),
        ]);
    };


    // --------------------- GENERIC ---------------------

    // compose (>>>) :: (a -> b) -> (b -> c) -> a -> c
    const compose = f =>
        g => x => f(g(x));


    // foldl :: (a -> b -> a) -> a -> [b] -> a
    const foldl = f =>
        a => xs => [...xs].reduce(
            (x, y) => f(x)(y),
            a
        );


    // identity :: a -> a
    const identity = x => x;


    // map :: (a -> b) -> [a] -> [b]
    const map = f =>
        // The list obtained by applying f
        // to each element of xs.
        // (The image of xs under f).
        xs => [...xs].map(f);


    // pred :: Enum a => a -> a
    const pred = x =>
        x - 1;


    // replicate :: Int -> a -> [a]
    const replicate = n =>
        // n instances of x.
        x => Array.from({
            length: n
        }, () => x);


    // succ :: Enum a => a -> a
    const succ = x =>
        1 + x;

    // MAIN ---
    console.log(JSON.stringify(main()));
})();
