(function (lstArrays) {

    return lstArrays.reduce(
        function (a, e) {
            return [
                a[0] + e[0],
                a[1] + e[1],
                a[2] + e[2]
            ];
        }, ['', '', ''] // initial copy of the accumulator
    ).join('\n');

})([
    ["a", "b", "c"],
    ["A", "B", "C"],
    ["1", "2", "3"]
]);
