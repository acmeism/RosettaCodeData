// Floyd triangles of 5 and 14 rows
// right-aligned monospaced columns (nMargin allows for extra spacing)
// () --> s
function main() {
    // minimum space between numbers - adjust for visual preference
    var nMargin = 1;

    // Formatted strings for Floyd's triangles of 5 and 14 rows
    return (function (lstN) {
        return lstN.map(function (nFloydRows) {
            var lstRows = floydIntegerLists(nFloydRows),
                iLast = nFloydRows - 1;

            return colsSpacedRight(
                lstRows,
                // Minimum space required per number cell
                // nMargin more than the width of the final number
                lstRows[iLast][iLast].toString().length + nMargin
            )
        }).join('\n\n');
    })([5, 14]);
}

// n Floyd's triangle rows
// n --> [[n]]
function floydIntegerLists(nRows) {

    // Full integer list folded into list of rows
    // [n] --> [[n]]
    return (function triangleNumbers(lstInt, startWidth) {
        var n = startWidth || 1;

        return n > lstInt.length ? [] : [lstInt.slice(0, n)].concat(
            triangleNumbers(lstInt.slice(n), n + 1)
        )
    })(
        range(
            1,
            Math.floor(
                (nRows * nRows) / 2
            ) + Math.ceil(
                nRows / 2
            )
        )
    );
}

// list of list of numbers --> lines of fixed right-aligned col width
// [[n]] --> s
function colsSpacedRight(lstLines, nColWidth) {
    return lstLines.reduce(
        function (s, line) {
            return s + line.map(function (n) {
                return rightAligned(n, nColWidth)
            }).join('') + '\n';
        }, ''
    )
}

// range(1, 20) --> [1..20]
function range(m, n) {
    return Array.apply(null, Array(n - m + 1)).map(
        function (x, i) {
            return m + i;
        }
    );
}

// Integer as right-padded string of given width
// n --> n --> s
function rightAligned(n, width) {
    var strN = n.toString();
    return Array(width - strN.length + 1).join(' ') + strN;
}

console.log( // if the context is a browser
    main()
);
