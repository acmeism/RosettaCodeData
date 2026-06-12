(function () {
    var concatMap = function (f, xs) {
        return [].concat.apply([], xs.map(f))
    };

    return function (n, xs) {
        return concatMap(function (x, ix) {
            return concatMap(function (y, iy) {
                return iy <= ix ? [] : x + y === n ? [
                    [ix, iy]
                ] : []
            }, xs)
        }, xs)
    }(21, [0, 2, 11, 19, 90]);
})();
