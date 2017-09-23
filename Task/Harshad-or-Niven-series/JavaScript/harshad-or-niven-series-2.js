(() => {
    'use strict';

    // HARSHADS ---------------------------------------------------------------

    // nHarshads :: Int -> [Int]
    const nHarshads = n => {

        // isHarshad :: Int -> Bool
        const isHarshad = n => 0 === n % sum(digitList(n));

        return until(
                dct => dct.nth === n,
                dct => {
                    const
                        next = succ(dct.i),
                        blnHarshad = isHarshad(next);
                    return {
                        i: next,
                        hs: blnHarshad ? dct.hs.concat(next) : dct.hs,
                        nth: dct.nth + (blnHarshad ? 1 : 0)
                    };
                }, {
                    i: 0,
                    hs: [],
                    nth: 0
                }
            )
            .hs;
    };

    // GENERIC FUNCTIONS ------------------------------------------------------

    // digitList :: Int -> [Int]
    const digitList = n =>
        n > 0 ? [n % 10].concat(digitList(Math.floor(n / 10))) : [];

    // dropWhile :: (a -> Bool) -> [a] -> [a]
    const dropWhile = (p, xs) => {
        let i = 0;
        for (let lng = xs.length;
            (i < lng) && p(xs[i]); i++) {}
        return xs.slice(i);
    };

    // head :: [a] -> a
    const head = xs => xs.length ? xs[0] : undefined;

    // a -> String
    const show = x => JSON.stringify(x, null, 2);

    // succ :: Int -> Int
    const succ = x => x + 1

    // sum :: (Num a) => [a] -> a
    const sum = xs => xs.reduce((a, x) => a + x, 0);

    // until :: (a -> Bool) -> (a -> a) -> a -> a
    const until = (p, f, x) => {
        const go = x => p(x) ? x : go(f(x));
        return go(x);
    };

    // TEST -------------------------------------------------------------------
    return show({
        firstTwenty: nHarshads(20),
        firstOver1000: head(dropWhile(x => x <= 1000, nHarshads(1000)))
    });
})();
