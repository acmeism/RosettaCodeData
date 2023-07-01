(function (xs) {

    return xs.reduce(function (a, x, i) {
        var n = i + 1,
            sum_ = a.sum + x,
            squaresSum_ = a.squaresSum + (x * x);

        return {
            sum: sum_,
            squaresSum: squaresSum_,
            stages: a.stages.concat(
                Math.sqrt((squaresSum_ / n) - Math.pow((sum_ / n), 2))
            )
        };

    }, {
        sum: 0,
        squaresSum: 0,
        stages: []
    }).stages

})([2, 4, 4, 4, 5, 5, 7, 9]);
