(function () {
    'use strict';

    // zipListsWith :: ([a] -> b) -> [[a]] -> [[b]]
    function zipListsWith(f, xss) {
        return (xss.length ? xss[0] : [])
            .map(function (_, i) {
                return f(xss.map(function (xs) {
                    return xs[i];
                }));
            });
    }

    // concat :: [a] -> s
    function concat(lst) {
        return ''.concat.apply('', lst);
    }

    // TEST
    return zipListsWith(
        concat,
        [["a", "b", "c"], ["A", "B", "C"], [1, 2, 3]]
    )
    .join('\n');
})();
