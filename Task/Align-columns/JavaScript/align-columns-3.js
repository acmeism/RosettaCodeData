(function (strText) {
    'use strict';

    // [[a]] -> [[a]]
    function transpose(lst) {
        return lst[0].map(function (_, iCol) {
            return lst.map(function (row) {
                return row[iCol];
            })
        });
    }

    // (a -> b -> c) -> [a] -> [b] -> [c]
    function zipWith(f, xs, ys) {
        return xs.length === ys.length ? (
            xs.map(function (x, i) {
                return f(x, ys[i]);
            })
        ) : undefined;
    }

    // (a -> a -> Ordering) -> [a] -> a
    function maximumBy(f, xs) {
        return xs.reduce(function (a, x) {
            return a === undefined ? x : (
                f(x) > f(a) ? x : a
            );
        }, undefined)
    }

    // [String] -> String
    function widest(lst) {
        return maximumBy(length, lst)
            .length;
    }

    // [[a]] -> [[a]]
    function fullRow(lst, n) {
        return lst.concat(Array.apply(null, Array(n - lst.length))
            .map(function () {
                return ''
            }));
    }

    // String -> Int -> String
    function nreps(s, n) {
        var o = '';
        if (n < 1) return o;
        while (n > 1) {
            if (n & 1) o += s;
            n >>= 1;
            s += s;
        }
        return o + s;
    }

    // [String] -> String
    function unwords(xs) {
        return xs.join('  ');
    }

    // [String] -> String
    function unlines(xs) {
        return xs.join('\n');
    }

    // [a] -> Int
    function length(xs) {
        return xs.length;
    }

    // -- Int -> [String] -> [[String]]
    function padWords(n, lstWords, eAlign) {
        return lstWords.map(function (w) {
            var lngPad = n - w.length;

            return (
                    (eAlign === eCenter) ? (function () {
                        var lngHalf = Math.floor(lngPad / 2);

                        return [
                            nreps(' ', lngHalf), w,
                            nreps(' ', lngPad - lngHalf)
                        ];
                    })() : (eAlign === eLeft) ?
                        ['', w, nreps(' ', lngPad)] :
                        [nreps(' ', lngPad), w, '']
                )
                .join('');
        });
    }

    // MAIN

    var eLeft = -1,
        eCenter = 0,
        eRight = 1;

    var lstRows = strText.split('\n')
        .map(function (x) {
            return x.split('$');
        }),

        lngCols = widest(lstRows),
        lstCols = transpose(lstRows.map(function (r) {
            return fullRow(r, lngCols)
        })),
        lstColWidths = lstCols.map(widest);

    // THREE PARAGRAPHS, WITH VARIOUS WORD COLUMN ALIGNMENTS:

    return [eLeft, eRight, eCenter]
        .map(function (eAlign) {
            var fPad = function (n, lstWords) {
                return padWords(n, lstWords, eAlign);
            };

            return transpose(
                    zipWith(fPad, lstColWidths, lstCols)
                )
                .map(unwords);
        })
        .map(unlines)
        .join('\n\n');

})(
    "Given$a$text$file$of$many$lines,$where$fields$within$a$line$\n\
are$delineated$by$a$single$'dollar'$character,$write$a$program\n\
that$aligns$each$column$of$fields$by$ensuring$that$words$in$each$\n\
column$are$separated$by$at$least$one$space.\n\
Further,$allow$for$each$word$in$a$column$to$be$either$left$\n\
justified,$right$justified,$or$center$justified$within$its$column."
);
