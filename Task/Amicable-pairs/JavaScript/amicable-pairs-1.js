(function (max) {

    // Proper divisors
    function properDivisors(n) {
        if (n < 2) return [];
        else {
            var rRoot = Math.sqrt(n),
                intRoot = Math.floor(rRoot),

                lows = range(1, intRoot).filter(function (x) {
                    return (n % x) === 0;
                });

            return lows.concat(lows.slice(1).map(function (x) {
                return n / x;
            }).reverse().slice((rRoot === intRoot) | 0));
        }
    }

    // [m..n]
    function range(m, n) {
        var a = Array(n - m + 1),
            i = n + 1;
        while (i--) a[i - 1] = i;
        return a;
    }

    // Filter an array of proper divisor sums,
    // reading the array index as a function of N (N-1)
    // and the sum of proper divisors as a potential M

    var pairs = range(1, max).map(function (x) {
        return properDivisors(x).reduce(function (a, d) {
            return a + d;
        }, 0)
    }).reduce(function (a, m, i, lst) {
        var n = i + 1;

        return (m > n) && lst[m - 1] === n ? a.concat([[n, m]]) : a;
    }, []);

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

    return wikiTable(
        [['N', 'M']].concat(pairs),
        true,
        'text-align:center'
    ) + '\n\n' + JSON.stringify(pairs);

})(20000);
