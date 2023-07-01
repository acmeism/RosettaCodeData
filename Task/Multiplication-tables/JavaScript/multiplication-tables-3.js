(function (m, n) {

    // [m..n]
    function range(m, n) {
        return Array.apply(null, Array(n - m + 1)).map(function (x, i) {
            return m + i;
        });
    }

    // Monadic bind (chain) for lists
    function mb(xs, f) {
        return [].concat.apply([], xs.map(f));
    }

    var rng = range(m, n),
        lstTable = [['x'].concat(   rng )]
                         .concat(mb(rng,   function (x) {
        return       [[x].concat(mb(rng,   function (y) {
            return y < x ? [''] : [x * y];               // triangle only
    }))]}));

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
