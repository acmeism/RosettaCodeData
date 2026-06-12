(function () {
    'use strict';

    function lcp() {
        var lst = [].slice.call(arguments),
            n = lst.length ? takewhile(same, zip.apply(null, lst)).length : 0;

        return n ? lst[0].substr(0, n) : '';
    }


    // (a -> Bool) -> [a] -> [a]
    function takewhile(p, lst) {
        var x = lst.length ? lst[0] : null;
        return x !== null && p(x) ? [x].concat(takewhile(p, lst.slice(1))) : [];
    }

    // Zip arbitrary number of lists (an imperative implementation)
    // [[a]] -> [[a]]
    function zip() {
        var lngLists = arguments.length,
            lngMin = Infinity,
            lstZip = [],
            arrTuple = [],
            lngLen, i, j;

        for (i = lngLists; i--;) {
            lngLen = arguments[i].length;
            if (lngLen < lngMin) lngMin = lngLen;
        }

        for (i = 0; i < lngMin; i++) {
            arrTuple = [];
            for (j = 0; j < lngLists; j++) {
                arrTuple.push(arguments[j][i]);
            }
            lstZip.push(arrTuple);
        }
        return lstZip;
    }

    // [a] -> Bool
    function same(lst) {
        return (lst.reduce(function (a, x) {
            return a === x ? a : null;
        }, lst[0])) !== null;
    }


    // TESTS

    return [
        lcp("interspecies", "interstellar", "interstate") === "inters",
        lcp("throne", "throne") === "throne",
        lcp("throne", "dungeon") === "",
        lcp("cheese") === "cheese",
        lcp("") === "",
        lcp("prefix", "suffix") === "",
        lcp("foo", "foobar") == "foo"
    ];

})();
