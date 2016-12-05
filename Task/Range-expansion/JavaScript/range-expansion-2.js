(function (strTest) {
    'use strict';

    // s -> [n]
    function expansion(strExpr) {

        // concat map yields flattened output list
        return [].concat.apply([], strExpr.split(',')
            .map(function (x) {
                return x.split('-')
                    .reduce(function (a, s, i, l) {

                        // negative (after item 0) if preceded by an empty string
                        // (i.e. a hyphen-split artefact, otherwise ignored)
                        return s.length ? i ? a.concat(
                            parseInt(l[i - 1].length ? s :
                                '-' + s, 10)
                        ) : [+s] : a;
                    }, []);

                // two-number lists are interpreted as ranges
            })
            .map(function (r) {
                return r.length > 1 ? range.apply(null, r) : r;
            }));
    }


    // [m..n]
    function range(m, n) {
        return Array.apply(null, Array(n - m + 1))
            .map(function (x, i) {
                return m + i;
            });
    }

    return expansion(strTest);

})('-6,-3--1,3-5,7-11,14,15,17-20');
