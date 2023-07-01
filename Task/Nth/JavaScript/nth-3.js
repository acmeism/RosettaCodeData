(function (lstTestRanges) {
    'use strict'

    let lstSuffix = 'th st nd rd th th th th th th'.split(' '),

        // ordinalString :: Int -> String
        ordinalString = n =>
            n.toString() + (
                11 <= n % 100 && 13 >= n % 100 ?
                "th" : lstSuffix[n % 10]
            ),

        // range :: Int -> Int -> [Int]
        range = (m, n) =>
            Array.from({
                length: (n - m) + 1
            }, (_, i) => m + i);


    return lstTestRanges
        .map(tpl => range
            .apply(null, tpl)
            .map(ordinalString)
        );

})([[0, 25], [250, 265], [1000, 1025]]);
