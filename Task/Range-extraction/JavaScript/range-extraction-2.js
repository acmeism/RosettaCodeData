(function (lstTest) {
    'use strict';

    function rangeString(xs) {
        var iRightmost = xs.length - 1,

            // Using foldr/reduceRight proves simpler here than foldl/reduce
            // (the left end of the list is easier to reach than the tip of the tail)
            lstSeries = xs.reduceRight(function (a, x, i, l) {

                return i < iRightmost ? (

                    // new series if rightward gap > 1
                    l[i + 1] - x > 1 ? (
                        [[x]].concat(a)
                    ) : (

                        // This value prepended to current series (if a
                        // series-breaker, or the start of the list, is at left)
                        (i === 0 || (x - l[i - 1]) > 1) ? (
                            [[x].concat(a[0])].concat(a.slice(1))

                            // or, if the series continues to the left,
                            // just an unmodified copy of the accumulator
                        ) : a
                    )
                ) : [[x]];

            }, []);

        return lstSeries.map(function (r) {
            var lng = r.length,
                d = lng > 1 ? r[1] - r[0] : 0;

            return d ? r[0] + (d > 1 ? '-' : ',') + r[1] : r[0];

        }).join(',');
    }

    return rangeString(lstTest);

})([0, 1, 2, 4, 6, 7, 8, 11, 12, 14,
   15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
   25, 27, 28, 29, 30, 31, 32, 33, 35, 36,
   37, 38, 39]);
