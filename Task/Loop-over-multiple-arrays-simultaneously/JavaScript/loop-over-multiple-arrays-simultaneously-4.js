(function (x, y, z) {

    // function of arity 3 mapped over nth items of each of 3 lists
    // (a -> b -> c -> d) -> [a] -> [b] -> [c] -> [d]
    function zipWith3(f, xs, ys, zs) {
        return zs.length ? [f(xs[0], ys[0], zs[0])].concat(
            zipWith3(f, xs.slice(1), ys.slice(1), zs.slice(1))) : [];
    }

    function concat(x, y, z) {
        return ''.concat(x, y, z);
    }

    return zipWith3(concat, x, y, z).join('\n')

})(["a", "b", "c"], ["A", "B", "C"], [1, 2, 3]);
