(function () {

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

    var tblOneToTen = [
            ['Number', 'Proper Divisors', 'Count']
        ].concat(range(1, 10).map(function (x) {
            var ds = properDivisors(x);

            return [x, ds.join(', '), ds.length];
        })),

        dctMostBelow20k = range(1, 20000).reduce(function (a, x) {
            var lng = properDivisors(x).length;

            return lng > a.divisorCount ? {
                n: x,
                divisorCount: lng
            } : a;
        }, {
            n: 0,
            divisorCount: 0
        });


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
        tblOneToTen,
        true
    ) + '\n\nMost proper divisors below 20,000:\n\n  ' + JSON.stringify(
        dctMostBelow20k
    );

})();
