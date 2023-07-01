(() => {

    // maxSubseq :: [Int] -> (Int, [Int])
    const maxSubseq = xs =>
        snd(xs.reduce((tpl, x) => {
            const [m1, m2] = Array.from(fst(tpl)),
                high = max(
                    Tuple(0, []),
                    Tuple(m1 + x, m2.concat(x))
                );
            return Tuple(high, max(snd(tpl), high));
        }, Tuple(Tuple(0, []), Tuple(0, []))));


    // TEST -----------------------------------------------
    // main :: IO ()
    const main = () => {
        const mx = maxSubseq([-1, -2, 3, 5, 6, -2, -1, 4, -4, 2, -1]);
        showLog(snd(mx), fst(mx))
    }
    // [3,5,6,-2,-1,4] -> 15


    // GENERIC FUNCTIONS ----------------------------------

    // fst :: (a, b) -> a
    const fst = tpl => tpl[0];

    // gt :: Ord a => a -> a -> Bool
    const gt = (x, y) =>
        'Tuple' === x.type ? (
            x[0] > y[0]
        ) : (x > y);

    // max :: Ord a => a -> a -> a
    const max = (a, b) => gt(b, a) ? b : a;

    // showLog :: a -> IO ()
    const showLog = (...args) =>
        console.log(
            args
            .map(JSON.stringify)
            .join(' -> ')
        );

    // snd :: (a, b) -> b
    const snd = tpl => tpl[1];

    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = (a, b) => ({
        type: 'Tuple',
        '0': a,
        '1': b,
        length: 2
    });

    // MAIN ---
    return main();
})();
