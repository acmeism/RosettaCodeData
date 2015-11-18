(function (lines) {

    var LEFT = 0,
        CENTRE = 1,
        RIGHT = 2;

    return alignedTable(
        lines.map(function (s) {
            return s.split('$');
        }),
        2,      // minimum gap between cols
        LEFT    // [LEFT|CENTRE|RIGHT] or [0|1|2]
    )

    // TABULATION OF RESULTS IN SPACED AND ALIGNED COLUMNS
    // [s] -> n -> enum -> s
    function alignedTable(lstRows, lngPad, iAlignment) {

        // Max width of each column
        var lstColWidths = range(0, lstRows.reduce(function (a, x) {
            return x.length > a ? x.length : a;
        }, 0) - 1).map(function (iCol) {
            return lstRows.reduce(function (a, lst) {
                var w = lst[iCol] ? lst[iCol].toString().length : 0;
                return (w > a) ? w : a;
            }, 0);
        });

        // Rows padded to equal width
        return lstRows.map(function (lstRow) {
            return lstRow.map(function (v, i) {
                return align(v, lstColWidths[i] + lngPad, iAlignment);
            }).join('')
        }).join('\n');
    }

    // Text padded to left and/or right: aligned (left|centre|right)
    // String, number of characters, alignment 0|1|2
    // s -> n -> enum -> s
    function align(s, n, a) {
        var mid = (1 === a),
            gap = n - s.length,
            pad = Array(Math.floor((gap + 1) / (mid ? 2 : 1))).join(' ');

        return (a ? pad + (!mid || gap % 2 ? '' : ' ') : '') + s +
            (2 > a ? pad + (mid ? ' ' : '') : '');
    }

    // [m..n]
    function range(m, n) {
        return Array.apply(null, Array(n - m + 1)).map(function (x, i) {
            return m + i;
        });
    }

})([
  "Given$a$text$file$of$many$lines,$where$fields$within$a$line$",
  "are$delineated$by$a$single$'dollar'$character,$write$a$program",
  "that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$",
  "column$are$separated$by$at$least$one$space.",
  "Further,$allow$for$each$word$in$a$column$to$be$either$left$",
  "justified,$right$justified,$or$center$justified$within$its$column."
]);
