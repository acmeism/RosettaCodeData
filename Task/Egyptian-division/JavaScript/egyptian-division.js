(() => {
    'use strict';

    // EGYPTIAN DIVISION --------------------------------

    // eqyptianQuotRem :: Int -> Int -> (Int, Int)
    const eqyptianQuotRem = (m, n) => {
        const expansion = ([i, x]) =>
            x > m ? (
                Nothing()
            ) : Just([
                [i, x],
                [i + i, x + x]
            ]);
        const collapse = ([i, x], [q, r]) =>
            x < r ? (
                [q + i, r - x]
            ) : [q, r];
        return foldr(
            collapse,
            [0, m],
            unfoldr(expansion, [1, n])
        );
    };

    // TEST ---------------------------------------------

    // main :: IO ()
    const main = () =>
        showLog(
            eqyptianQuotRem(580, 34)
        );
        // -> [17, 2]



    // GENERIC FUNCTIONS --------------------------------

    // Just :: a -> Maybe a
    const Just = x => ({
        type: 'Maybe',
        Nothing: false,
        Just: x
    });

    // Nothing :: Maybe a
    const Nothing = () => ({
        type: 'Maybe',
        Nothing: true,
    });

    // flip :: (a -> b -> c) -> b -> a -> c
    const flip = f =>
        1 < f.length ? (
            (a, b) => f(b, a)
        ) : (x => y => f(y)(x));


    // foldr :: (a -> b -> b) -> b -> [a] -> b
    const foldr = (f, a, xs) => xs.reduceRight(flip(f), a);


    // unfoldr :: (b -> Maybe (a, b)) -> b -> [a]
    const unfoldr = (f, v) => {
        let
            xr = [v, v],
            xs = [];
        while (true) {
            const mb = f(xr[1]);
            if (mb.Nothing) {
                return xs
            } else {
                xr = mb.Just;
                xs.push(xr[0])
            }
        }
    };

    // showLog :: a -> IO ()
    const showLog = (...args) =>
        console.log(
            args
            .map(JSON.stringify)
            .join(' -> ')
        );

    // MAIN ---
    return main();
})();
