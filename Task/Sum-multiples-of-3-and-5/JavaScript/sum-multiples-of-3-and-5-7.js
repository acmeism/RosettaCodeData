(() => {

    // Area under straight line
    // between first multiple and last
    let sumMults = (n, factor) => {
            let n1 = Math.floor((n - 1) / factor);

            return Math.floor(factor * n1 * (n1 + 1) / 2);
        },

        sum35 = (n) => sumMults(n, 3) + sumMults(n, 5) - sumMults(n, 15);


    // TEST

    // range(intFrom, intTo, optional intStep)
    // Int -> Int -> Maybe Int -> [Int]
    let range = (m, n, step) => {
        let d = (step || 1) * (n >= m ? 1 : -1);

        return Array.from({
            length: Math.floor((n - m) / d) + 1
        }, (_, i) => m + (i * d));
    }

    // Sums for 10^1 thru 10^8

    return range(1, 8)
        .map(n => Math.pow(10, n))
        .reduce((a, x) => (
            a[x.toString()] = sum35(x),
            a
        ), {});

})();
