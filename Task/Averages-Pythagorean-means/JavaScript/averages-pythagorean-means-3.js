(() => {

    // arithmeticMean :: [Number] -> Number
    const arithmeticMean = xs =>
        xs.reduce((sum, n) => sum + n, 0) / xs.length;

    // geometricMean :: [Number] -> Number
    const geometricMean = xs =>
        Math.pow(xs.reduce((product, x) => product * x, 1), 1 / xs.length);

    // harmonicMean :: [Number] -> Number
    const harmonicMean = xs =>
        xs.length / xs.reduce((invSum, n) => invSum + (1 / n), 0);


    // TEST
    const values = [arithmeticMean, geometricMean, harmonicMean]
        .map(f => f([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])),

        mean = {
            Arithmetic: values[0],
            Geometric: values[1],
            Harmonic: values[2]
        };

    return JSON.stringify({
        values: mean,
        test: `is A >= G >= H ? ${mean.Arithmetic >= mean.Geometric &&
            mean.Geometric >= mean.Harmonic ? "yes" : "no"}`
    }, null, 2);

})();
