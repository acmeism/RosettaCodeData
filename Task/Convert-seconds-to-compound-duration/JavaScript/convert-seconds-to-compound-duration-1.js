(function () {
    'use strict';

    // angloDuration :: Int -> String
    function angloDuration(intSeconds) {
        return zip(
                weekParts(intSeconds),
                ['wk', 'd', 'hr', 'min','sec']
            )
            .reduce(function (a, x) {
                return a.concat(x[0] ? (
                    [(x[0].toString() + ' ' + x[1])]
                ) : []);
            }, [])
            .join(', ');
    }



    // weekParts :: Int -> [Int]
    function weekParts(intSeconds) {

        return [undefined, 7, 24, 60, 60]
            .reduceRight(function (a, x) {
                var intRest = a.remaining,
                    intMod = isNaN(x) ? intRest : intRest % x;

                return {
                    remaining:(intRest - intMod) / (x || 1),
                    parts: [intMod].concat(a.parts)
                };
            }, {
                remaining: intSeconds,
                parts: []
            })
            .parts
    }

    // GENERIC ZIP

    // zip :: [a] -> [b] -> [(a,b)]
    function zip(xs, ys) {
        return xs.length === ys.length ? (
            xs.map(function (x, i) {
                return [x, ys[i]];
            })
        ) : undefined;
    }

    // TEST

    return [7259, 86400, 6000000]
        .map(function (intSeconds) {
            return intSeconds.toString() +
                '    ->    ' + angloDuration(intSeconds);
        })
        .join('\n');

})();
