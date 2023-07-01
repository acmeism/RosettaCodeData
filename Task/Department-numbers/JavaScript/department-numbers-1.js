(function () {
    'use strict';

    // concatMap :: (a -> [b]) -> [a] -> [b]
    function concatMap(f, xs) {
        return [].concat.apply([], xs.map(f));
    };

    return '(Police, Sanitation, Fire)\n' +
        concatMap(function (x) {
            return concatMap(function (y) {
                return concatMap(function (z) {
                    return z !== y && 1 <= z && z <= 7 ? [
                        [x, y, z]
                    ] : [];
                }, [12 - (x + y)]);
            }, [1, 2, 3, 4, 5, 6, 7]);
        }, [2, 4, 6])
        .map(JSON.stringify)
        .join('\n');
})();
