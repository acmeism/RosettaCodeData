function im(n) {
    return Array.apply(null, new Array(n)).map(function(x, i, a) { return a.map(function(y, k) { return i === k ? 1 : 0; }) });
}
