function combinations(k, arr, prefix = []) {
    if (prefix.length == 0) arr = [...Array(arr).keys()];
    if (k == 0) return [prefix];
    return arr.flatMap((v, i) =>
        combinations(k - 1, arr.slice(i + 1), [...prefix, v])
    );
}
