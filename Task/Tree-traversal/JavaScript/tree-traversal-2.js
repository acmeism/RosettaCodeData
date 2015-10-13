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
                            [
                                x[0][l],
                                x[0][r]
                            ]
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
            ];

console.log(
    [preorder, inorder, postorder, levelorder].map(
        function (f) {
            return f.name + ':\t\t' + f(tree).join(' ');
        }
    ).join('\n')
);
