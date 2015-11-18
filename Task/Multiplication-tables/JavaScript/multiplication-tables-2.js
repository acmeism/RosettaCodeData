(function (m, n) {

    // [m..n]
    function range(m, n) {
        return Array.apply(null, Array(n - m + 1)).map(function (x, i) {
            return m + i;
        });
    }

    // Monadic bind (chain) for lists
    function chain(xs, f) {
        return [].concat.apply([], xs.map(f));
    }

    var lstRange = range(m, n),

        lstTable = [['x'].concat(lstRange)].concat(
            chain(lstRange, function (y) {
                return [[y].concat(
                    chain(lstRange, function (x) {
                        return x < y ? [''] : [x * y]; // triangle only
                    })
                )]
            })
        );


    /*                        FORMATTING OUTPUT                             */

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

    // Formatted as WikiTable
    return wikiTable(
        lstTable, true,
        'text-align:center;width:33em;height:33em;table-layout:fixed;'
    ) + '\n\n' +

    // or simply stringified as JSON
    JSON.stringify(lstTable);

})(1, 12);
