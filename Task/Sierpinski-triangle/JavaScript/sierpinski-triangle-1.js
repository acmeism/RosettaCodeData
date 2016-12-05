(function (order) {

    // Sierpinski triangle of order N constructed as
    // Pascal triangle of 2^N rows mod 2
    // with 1 encoded as "▲"
    // and 0 encoded as " "
    function sierpinski(intOrder) {
        return function asciiPascalMod2(intRows) {
            return range(1, intRows - 1)
                .reduce(function (lstRows) {
                    var lstPrevRow = lstRows.slice(-1)[0];

                    // Each new row is a function of the previous row
                    return lstRows.concat([zipWith(function (left, right) {
                        // The composition ( asciiBinary . mod 2 . add )
                        // reduces to a rule from 2 parent characters
                        // to a single child character

                        // Rule 90 also reduces to the same XOR
                        // relationship between left and right neighbours

                        return left === right ? " " : "▲";
                    }, [' '].concat(lstPrevRow), lstPrevRow.concat(' '))]);
                }, [
                    ["▲"] // Tip of triangle
                ]);
        }(Math.pow(2, intOrder))

        // As centred lines, from bottom (0 indent) up (indent below + 1)
        .reduceRight(function (sofar, lstLine) {
            return {
                triangle: sofar.indent + lstLine.join(" ") + "\n" +
                    sofar.triangle,
                indent: sofar.indent + " "
            };
        }, {
            triangle: "",
            indent: ""
        }).triangle;
    };

    var zipWith = function (f, xs, ys) {
            return xs.length === ys.length ? xs
                .map(function (x, i) {
                    return f(x, ys[i]);
                }) : undefined;
        },
        range = function (m, n) {
            return Array.apply(null, Array(n - m + 1))
                .map(function (x, i) {
                    return m + i;
                });
        };

    // TEST
    return sierpinski(order);

})(4);
