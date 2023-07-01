(function (lstFactors, intExponent) {

    // [n] -> n -> n
    function sumMultiplesBelow(lstIntegers, limit) {
        return range(1, limit - 1).filter(function (x) {
            return isMultiple(lstIntegers, x);
        }).reduce(function (a, n) {
            return a + n;
        }, 0)
    }

    // [n] -> n -> bool
    function isMultiple(lst, n) {
        var i = lng;
        while (i--)
            if (n % (lst[i]) === 0) return true;
        return false;
    }

    // [m..n]
    function range(m, n) {
        var a = Array(n - m + 1),
            i = n + 1;
        while (i--) a[i - 1] = i;
        return a;
    }


    /*      TESTING     */

    // [[a]] -> bool -> s -> s
    function wikiTable(lstRows, blnHeaderRow, strStyle) {
        return '{| class="wikitable" ' + (
            strStyle ? 'style="' + strStyle + '"' : ''
        ) + lstRows.map(function (lstRow, iRow) {
            var strDelim = ((blnHeaderRow && !iRow) ? '!' : '|');

            return '\n|-\n' + strDelim + ' ' + lstRow.map(function (v) {
                return typeof v === 'undefined' ? ' ' : v;
            }).join(' ' + strDelim + strDelim + ' ');
        }).join('') + '\n|}';
    }

    var lng = lstFactors.length,
        lstSorted = lstFactors.slice(0).sort();

    var lstTable = [['Below', 'Sum']].concat(
        range(1, intExponent).map(function (x) {
            var pwr = Math.pow(10, x);

            return ['10^' + x, sumMultiplesBelow(lstSorted, pwr)];
        })
    );

    return 'For ' + JSON.stringify(lstFactors) + ':\n\n' +
        wikiTable(lstTable, true) + '\n\n' +
        JSON.stringify(lstTable);

})([3, 5], 8);
