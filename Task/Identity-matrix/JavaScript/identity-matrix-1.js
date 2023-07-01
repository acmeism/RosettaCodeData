function idMatrix(n) {
    return Array.apply(null, new Array(n))
        .map(function (x, i, xs) {
            return xs.map(function (_, k) {
                return i === k ? 1 : 0;
            })
        });
}
