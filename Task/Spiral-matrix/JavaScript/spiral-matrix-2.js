(function (n) {

    // Spiral: the first row plus a smaller spiral rotated 90 degrees clockwise
    function spiral(lngRows, lngCols, nStart) {
        return lngRows ? [range(nStart, (nStart + lngCols) - 1)].concat(
            transpose(
                spiral(lngCols, lngRows - 1, nStart + lngCols)
            ).map(reverse)
        ) : [[]];
    }

    // rows and columns transposed (for 90 degree rotation)
    function transpose(lst) {
        return lst.length > 1 ? lst[0].map(
            function (_, col) {
                return lst.map(function (row) {
                    return row[col];
                });
            }
        ) : lst;
    }

    // elements in reverse order (for 90 degree rotation)
    function reverse(lst) {
        return lst.length > 1 ? lst.reduceRight(
            function (acc, x) {
                return acc.concat(x);
            }, []
        ) : lst;
    }

    // [m..n]
    function range(m, n) {
        return Array.apply(null, Array(n - m + 1)).map(
            function (x, i) {
                return m + i;
            }
        );
    }

    // Width of column for spaced display ?
    var lngColWidth = ((n * n) - 1).toString().length + 2;

    // Numeric columns right-aligned
    return spiral(n, n, 0).map(function (l) {
        return l.reduce(function (a, x) {
            var s = x.toString();

            return a + Array(
                lngColWidth - s.length
            ).join(' ') + s;
        }, '');
    }).join('\n')

})(5);
