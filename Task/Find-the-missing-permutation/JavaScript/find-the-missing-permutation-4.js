(() => {
    'use strict';

    // transpose :: [[a]] -> [[a]]
    let transpose = xs =>
        xs[0].map((_, iCol) => xs
            .map((row) => row[iCol]));


    let xs = 'ABCD CABD ACDB DACB BCDA ACBD ADCB CDAB' +
        ' DABC BCAD CADB CDBA CBAD ABDC ADBC BDCA DCBA' +
        ' BACD BADC BDAC CBDA DBCA DCAB'

    return transpose(xs.split(' ')
            .map(x => x.split('')))
        .map(col => col.reduce((a, x) => ( // count of each character in each column
            a[x] = (a[x] || 0) + 1,
            a
        ), {}))
        .map(dct => { // character with frequency below mean of distribution ?
            let ks = Object.keys(dct),
                xs = ks.map(k => dct[k]),
                mean = xs.reduce((a, b) => a + b, 0) / xs.length;

            return ks.reduce(
                (a, k) => a ? a : (dct[k] < mean ? k : undefined),
                undefined
            );
        })
        .join(''); // 4 chars as single string

    // --> 'DBAC'
})();
