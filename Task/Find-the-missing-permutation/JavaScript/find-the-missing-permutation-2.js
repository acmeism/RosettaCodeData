(function (strList) {

    // [a] -> [[a]]
    function permutations(xs) {
        return xs.length ? (
            chain(xs, function (x) {
                return chain(permutations(deleted(x, xs)), function (ys) {
                    return [[x].concat(ys).join('')];
                })
            })) : [[]];
    }

    // Monadic bind/chain for lists
    // [a] -> (a -> b) -> [b]
    function chain(xs, f) {
        return [].concat.apply([], xs.map(f));
    }

    // a -> [a] -> [a]
    function deleted(x, xs) {
        return xs.length ? (
            x === xs[0] ? xs.slice(1) : [xs[0]].concat(
                deleted(x, xs.slice(1))
            )
        ) : [];
    }

    // Provided subset
    var lstSubSet = strList.split('\n');

    // Any missing permutations
    // (we can use fold/reduce, filter, or chain (concat map) here)
    return chain(permutations('ABCD'.split('')), function (x) {
        return lstSubSet.indexOf(x) === -1 ? [x] : [];
    });

})(
    'ABCD\nCABD\nACDB\nDACB\nBCDA\nACBD\nADCB\nCDAB\nDABC\nBCAD\nCADB\n\
CDBA\nCBAD\nABDC\nADBC\nBDCA\nDCBA\nBACD\nBADC\nBDAC\nCBDA\nDBCA\nDCAB'
);
