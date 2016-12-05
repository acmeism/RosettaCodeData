(function () {
    'use strict';

    // arithmetic_mean :: [Number] -> Number
    function arithmetic_mean(ns) {
        return (
            ns.reduce( // sum
                function (sum, n) {
                    return (sum + n);
                },
                0
            ) / ns.length
        );
    }

    // geometric_mean :: [Number] -> Number
    function geometric_mean(ns) {
        return Math.pow(
            ns.reduce( // product
                function (product, n) {
                    return (product * n);
                },
                1
            ),
            1 / ns.length
        );
    }

    // harmonic_mean :: [Number] -> Number
    function harmonic_mean(ns) {
        return (
            ns.length / ns.reduce( // sum of inverses
                function (invSum, n) {
                    return (invSum + (1 / n));
                },
                0
            )
        );
    }

    var values = [arithmetic_mean, geometric_mean, harmonic_mean]
        .map(function (f) {
            return f([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]);
        }),
        mean = {
            Arithmetic: values[0], // arithmetic
            Geometric: values[1], // geometric
            Harmonic: values[2] // harmonic
        }

    return JSON.stringify({
        values: mean,
        test: "is A >= G >= H ? " +
            (
                mean.Arithmetic >= mean.Geometric &&
                mean.Geometric >= mean.Harmonic ? "yes" : "no"
            )
    }, null, 2);

})();
