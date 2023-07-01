(function () {

    function preorder(n) {
        return [n[v]].concat(
            n[l] ? preorder(n[l]) : []
        ).concat(
            n[r] ? preorder(n[r]) : []
        );
    }

    function inorder(n) {
        return (
            n[l] ? inorder(n[l]) : []
        ).concat(
            n[v]
        ).concat(
            n[r] ? inorder(n[r]) : []
        );
    }

    function postorder(n) {
        return (
            n[l] ? postorder(n[l]) : []
        ).concat(
            n[r] ? postorder(n[r]) : []
        ).concat(
            n[v]
        );
    }

    function levelorder(n) {
        return (function loop(x) {
            return x.length ? (
                x[0] ? (
                [x[0][v]].concat(
                        loop(
                            x.slice(1).concat(
                                [x[0][l], x[0][r]]
                            )
                        )
                    )
                ) : loop(x.slice(1))
            ) : [];
        })([n]);
    }

    var v = 0,
        l = 1,
        r = 2,

        tree = [1,
                [2,
                    [4,
                        [7]
                    ],
                    [5]
                ],
                [3,
                    [6,
                        [8],
                        [9]
                    ]
                ]
            ],

        lstTest = [["Traversal", "Nodes visited"]].concat(
            [preorder, inorder, postorder, levelorder].map(
                function (f) {
                    return [f.name, f(tree)];
                }
            )
        );

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

    return wikiTable(lstTest, true) + '\n\n' + JSON.stringify(lstTest);

})();
