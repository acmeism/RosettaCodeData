(function () {

    // hanoi :: Int -> String -> String -> String -> [[String, String]]
    function hanoi(n, a, b, c) {
        return n ? hanoi(n - 1, a, c, b)
            .concat([
                [a, b]
            ])
            .concat(hanoi(n - 1, c, b, a)) : [];
    }

    return hanoi(3, 'left', 'right', 'mid')
        .map(function (d) {
            return d[0] + ' -> ' + d[1];
        });
})();
