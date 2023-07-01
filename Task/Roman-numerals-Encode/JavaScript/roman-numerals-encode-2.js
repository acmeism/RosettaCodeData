(function () {
    'use strict';


    // If the Roman is a string, pass any delimiters through

    // (Int | String) -> String
    function romanTranscription(a) {
        if (typeof a === 'string') {
            var ps = a.split(/\d+/),
                dlm = ps.length > 1 ? ps[1] : undefined;

            return (dlm ? a.split(dlm)
                    .map(function (x) {
                        return Number(x);
                    }) : [a])
                .map(roman)
                .join(dlm);
        } else return roman(a);
    }

    // roman :: Int -> String
    function roman(n) {
        return [[1000, "M"], [900, "CM"], [500, "D"], [400, "CD"], [100,
        "C"], [90, "XC"], [50, "L"], [40, "XL"], [10, "X"], [9,
        "IX"], [5, "V"], [4, "IV"], [1, "I"]]
            .reduce(function (a, lstPair) {
                var m = a.remainder,
                    v = lstPair[0];

                return (v > m ? a : {
                    remainder: m % v,
                    roman: a.roman + Array(
                            Math.floor(m / v) + 1
                        )
                        .join(lstPair[1])
                });
            }, {
                remainder: n,
                roman: ''
            }).roman;
    }

    // TEST

    return [2016, 1990, 2008, "14.09.2015", 2000, 1666].map(
        romanTranscription);

})();
