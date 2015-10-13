select(nTuples(range(1, 100), 3), function ([x, y, z]) {
    return x * x + y * y === z * z;
});

// nTuples(range(20), 3) --> [[1, 2, 3], [1, 2, 4]  ... [17, 19, 20], [18, 19, 20]] (1140 tuples)
function nTuples(lst, n) {
    var m = lst.length,
        x = m ? [lst[0]] : null,
        xs = m ? lst.slice(1) : null;

    return (!n || m < n) ? [] : (
        n === 1 ? lst.map(function (p) {
            return [p];
        }) : (
            nTuples(xs, n - 1).map(function (t) {
                return x.concat(t);
            }).concat(nTuples(xs, n))
        )
    )
}

// range(1, 20) --> [1..20]
function range(m, n) {
    return Array.apply(null, Array(n - m + 1)).map(
        function (x, i) {
            return m + i;
        }
    )
}

function select(lstSet, fnPredicate) {
    return lstSet.filter(fnPredicate);
}
