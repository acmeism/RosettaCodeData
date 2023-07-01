(() => {
    const main = () => {

        console.log(
            'First 15 Recaman:\n' +
            recamanUpto(i => 15 === i)
        );

        console.log(
            '\n\nFirst duplicated Recaman:\n' +
            last(recamanUpto(
                (_, set, rs) => set.size !== rs.length
            ))
        );

        const setK = new Set(enumFromTo(0, 1000));
        console.log(
            '\n\nNumber of Recaman terms needed to generate' +
            '\nall integers from [0..1000]:\n' +
            (recamanUpto(
                (_, setR) => isSubSetOf(setK, setR)
            ).length - 1)
        );
    };

    // RECAMAN --------------------------------------------

    // recamanUpto :: (Int -> Set Int > [Int] -> Bool) -> [Int]
    const recamanUpto = p => {
        let
            i = 1,
            r = 0, // First term of series
            rs = [r];
        const seen = new Set(rs);
        while (!p(i, seen, rs)) {
            r = nextR(seen, i, r);
            seen.add(r);
            rs.push(r);
            i++;
        }
        return rs;
    }

    // Next Recaman number.

    // nextR :: Set Int -> Int -> Int
    const nextR = (seen, i, n) => {
        const back = n - i;
        return (0 > back || seen.has(back)) ? (
            n + i
        ) : back;
    };

    // GENERIC --------------------------------------------

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = (m, n) =>
        m <= n ? iterateUntil(
            x => n <= x,
            x => 1 + x,
            m
        ) : [];

    // isSubsetOf :: Ord a => Set a -> Set a -> Bool
    const isSubSetOf = (a, b) => {
        for (let x of a) {
            if (!b.has(x)) return false;
        }
        return true;
    };

    // iterateUntil :: (a -> Bool) -> (a -> a) -> a -> [a]
    const iterateUntil = (p, f, x) => {
        const vs = [x];
        let h = x;
        while (!p(h))(h = f(h), vs.push(h));
        return vs;
    };

    // last :: [a] -> a
    const last = xs =>
        0 < xs.length ? xs.slice(-1)[0] : undefined;

    // MAIN ------------------------------------------------
    return main();
})();
