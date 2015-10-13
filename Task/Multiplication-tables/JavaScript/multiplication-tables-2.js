// [1..12]
// n --> n --> [n]
function range(m, n) {
    return Array.apply(
        null, Array(n - m + 1)
    ).map(function (x, i) {
        return m + i;
    });
}

// '   1' .. ' 144'
// n --> n --> s
function cell(n, w) {
    return Array(w - n.toString().length + 1).join(' ') + n;
}


// Heading and table
// n --> n --> n --> s
(function (m, n, colWidth) {

        // 1.. 12
    var lstRange = range(m, n),

        // 5 space column widths
        pad = function (x) { return cell(x || ' ', colWidth) },

        // x    1    2    3    4    5    6    7    8    9   10   11   12
        lstTable = [['x'].concat(lstRange)].concat(

            lstRange.map(function (iRow, i, lst) {

                // multiplier
                return [iRow].concat(

                    // gap to left (triangle of numbers only)
                    Array.apply(null, Array(i)).concat(

                        // products
                        lst.slice(i).map(function (x) {
                            return x * iRow;
                        })
                    )
                );
            })
        );

    // Stringified table of padded lines
    // [[s]] --> s
    return lstTable.map(function (row) {
        return row.map(pad).join('');
    }).join('\n');

})(1, 12, 5);
