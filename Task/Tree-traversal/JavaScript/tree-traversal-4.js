(function () {
    'use strict';

    // 'preorder' | 'inorder' | 'postorder' | 'level-order'

    // traverse :: String -> Tree {value: a, nest: [Tree]} -> [a]
    function traverse(strOrderName, dctTree) {
        var strName = strOrderName.toLowerCase();

        if (strName.startsWith('level')) {

            // LEVEL-ORDER
            return levelOrder([dctTree]);

        } else if (strName.startsWith('in')) {
            var lstNest = dctTree.nest;

            if ((lstNest ? lstNest.length : 0) < 3) {
                var left = lstNest[0] || [],
                    right = lstNest[1] || [],

                    lstLeft = left.nest ? (
                        traverse(strName, left)
                    ) : (left.value || []),
                    lstRight = right.nest ? (
                        traverse(strName, right)
                    ) : (right.value || []);

                return (lstLeft !== undefined && lstRight !== undefined) ?

                    // IN-ORDER
                    (lstLeft instanceof Array ? lstLeft : [lstLeft])
                    .concat(dctTree.value)
                    .concat(lstRight) : undefined;

            } else { // in-order only defined here for binary trees
                return undefined;
            }

        } else {
            var lstTraversed = concatMap(function (x) {
                return traverse(strName, x);
            }, (dctTree.nest || []));

            return (
                strName.startsWith('pre') ? (

                    // PRE-ORDER
                    [dctTree.value].concat(lstTraversed)

                ) : strName.startsWith('post') ? (

                    // POST-ORDER
                    lstTraversed.concat(dctTree.value)

                ) : []
            );
        }
    }

    // levelOrder :: [Tree {value: a, nest: [Tree]}] -> [a]
    function levelOrder(lstTree) {
        var lngTree = lstTree.length,
            head = lngTree ? lstTree[0] : undefined,
            tail = lstTree.slice(1);

        // Recursively take any value found in the head node
        // of the remaining tail, deferring any child nodes
        // of that head to the end of the tail
        return lngTree ? (
            head ? (
                [head.value].concat(
                    levelOrder(
                        tail
                        .concat(head.nest || [])
                    )
                )
            ) : levelOrder(tail)
        ) : [];
    }

    // concatMap :: (a -> [b]) -> [a] -> [b]
    function concatMap(f, xs) {
        return [].concat.apply([], xs.map(f));
    }

    var dctTree = {
        value: 1,
        nest: [{
            value: 2,
            nest: [{
                value: 4,
                nest: [{
                    value: 7
                }]
            }, {
                value: 5
            }]
        }, {
            value: 3,
            nest: [{
                value: 6,
                nest: [{
                    value: 8
                }, {
                    value: 9
                }]
            }]
        }]
    };


    return ['preorder', 'inorder', 'postorder', 'level-order']
        .reduce(function (a, k) {
            return (
                a[k] = traverse(k, dctTree),
                a
            );
        }, {});

})();
