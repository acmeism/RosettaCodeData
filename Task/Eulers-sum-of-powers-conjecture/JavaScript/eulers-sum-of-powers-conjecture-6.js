(() => {
    'use strict';

    const eulersSumOfPowers = intMax => {
        const
            pow = Math.pow,
            xs = range(0, intMax)
            .map(x => pow(x, 5)),
            dct = xs.reduce((a, x, i) =>
                (a[x] = i,
                    a
                ), {});

        for (let a = 1; a <= intMax; a++) {
            for (let b = 2; b <= a; b++) {
                for (let c = 3; c <= b; c++) {
                    for (let d = 4; d <= c; d++) {
                        const sumOfPower = dct[xs[a] + xs[b] + xs[c] + xs[d]];
                        if (sumOfPower !== undefined) {
                            return [a, b, c, d, sumOfPower];
                        }
                    }
                }
            }
        }
        return undefined;
    };

    // range :: Int -> Int -> [Int]
    const range = (m, n) =>
        Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i);

    // TEST
    const soln = eulersSumOfPowers(250);
    return soln ? soln.slice(0, 4)
        .map(x => `${x}^5`)
        .join(' + ') + ` = ${soln[4]}^5` : 'No solution found.'

})();
