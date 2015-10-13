// Orders 1, 2 and 3 of the Sierpinski Carpet
// as lines of text.

// Generic text output for use in any JavaScript environment
// Browser JavaScripts may use console.log() to return textual output
// others use print() or analogous functions.

[1, 2, 3].map(function sierpinskiCarpetOrder(n) {

    // An (n * n) grid of (filled or empty) sub-rectangles
    // n --> [[s]]
    var carpet = function (n) {
            var lstN = range(0, Math.pow(3, n) - 1);

            // State of each cell in an N * N grid
            return lstN.map(function (x) {
                return lstN.map(function (y) {
                    return inCarpet(x, y);
                });
            });
        },

        // State of a given coordinate in the grid:
        // Filled or not ?
        // (See https://en.wikipedia.org/wiki/Sierpinski_carpet#Construction)
        // n --> n --> bool
        inCarpet = function (x, y) {
            return (!x || !y) ? true :
                !(
                    (x % 3 === 1) &&
                    (y % 3 === 1)
                ) && inCarpet(
                    x / 3 | 0,
                    y / 3 | 0
                );
        },

        // Sequence of integers from m to n
        // n --> n --> [n]
        range = function (m, n) {
            return Array.apply(null, Array(n - m + 1)).map(
                function (x, i) {
                    return m + i;
                }
            );
        };

    // Grid of booleans mapped to lines of characters
    // [[bool]] --> s
    return carpet(n).map(function (line) {
        return line.map(function (bool) {
            return bool ? '\u2588' : ' ';
        }).join('');
    }).join('\n');

}).join('\n\n');
