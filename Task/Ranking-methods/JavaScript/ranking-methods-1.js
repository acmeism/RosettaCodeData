(function () {

    var xs = 'Solomon Jason Errol Garry Bernard Barry Stephen'.split(' '),
        ns = [44, 42, 42, 41, 41, 41, 39],

        sorted = xs.map(function (x, i) {
            return { name: x, score: ns[i] };
        }).sort(function (a, b) {
            var c = b.score - a.score;
            return c ? c : a.name < b.name ? -1 : a.name > b.name ? 1 : 0;
        }),

        names = sorted.map(function (x) { return x.name; }),
        scores = sorted.map(function (x) { return x.score; }),

        reversed = scores.slice(0).reverse(),
        unique = scores.filter(function (x, i) {
            return scores.indexOf(x) === i;
        });

    // RANKINGS AS FUNCTIONS OF SCORES: SORTED, REVERSED AND UNIQUE

    var rankings = function (score, index) {
            return {
                name: names[index],
                score: score,

                Ordinal: index + 1,

                Standard: function (n) {
                    return scores.indexOf(n) + 1;
                }(score),

                Modified: function (n) {
                    return reversed.length - reversed.indexOf(n);
                }(score),

                Dense: function (n) {
                    return unique.indexOf(n) + 1;
                }(score),

                Fractional: function (n) {
                    return (
                        (scores.indexOf(n) + 1) +
                        (reversed.length - reversed.indexOf(n))
                    ) / 2;
                }(score)
            };
        },

        tbl = [
            'Name Score Standard Modified Dense Ordinal Fractional'.split(' ')
        ].concat(scores.map(rankings).reduce(function (a, x) {
            return a.concat([
                [x.name, x.score,
                    x.Standard, x.Modified, x.Dense, x.Ordinal, x.Fractional
                ]
            ]);
        }, [])),

        //[[a]] -> bool -> s -> s
        wikiTable = function (lstRows, blnHeaderRow, strStyle) {
            return '{| class="wikitable" ' + (
                strStyle ? 'style="' + strStyle + '"' : ''
            ) + lstRows.map(function (lstRow, iRow) {
                var strDelim = ((blnHeaderRow && !iRow) ? '!' : '|');

                return '\n|-\n' + strDelim + ' ' + lstRow.map(function (v) {
                    return typeof v === 'undefined' ? ' ' : v;
                }).join(' ' + strDelim + strDelim + ' ');
            }).join('') + '\n|}';
        };

    return wikiTable(tbl, true, 'text-align:center');

})();
