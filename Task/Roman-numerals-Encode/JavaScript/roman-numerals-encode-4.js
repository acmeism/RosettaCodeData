(() => {
    'use strict';

    // roman :: Int -> String
    const roman = n => [
            [1000, "M"],
            [900, "CM"],
            [500, "D"],
            [400, "CD"],
            [100,"C"],
            [90, "XC"],
            [50, "L"],
            [40, "XL"],
            [10, "X"],
            [9,"IX"],
            [5, "V"],
            [4, "IV"],
            [1, "I"]
        ]
        .reduce((a, lstPair) => {
            const m = a.remainder,
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
        })
        .roman;

    // TEST

    // If the input is a decimal string, pass any delimiters through
    // romanTranscription :: (Int | String) -> String
    const romanTranscription = a => {
        if (typeof a === 'string') {
            const ps = a.split(/\d+/),
                dlm = ps.length > 1 ? ps[1] : undefined;

            return (dlm ? a.split(dlm)
                    .map(Number) : [a])
                .map(roman)
                .join(dlm);
        } else return roman(a);
    }

    // TEST
    return [2016, 1990, 2008, "14.09.2015", 2000, 1666]
        .map(romanTranscription);
})();
