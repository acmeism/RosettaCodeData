(function (n) {
    "use strict";
    return range(1, 100)
        .filter(function (x) {
            return integerFactors(x)
                .length % 2;
        });
    function integerFactors(n) {
        var rRoot = Math.sqrt(n),
            intRoot = Math.floor(rRoot),
            lows = range(1, intRoot)
            .filter(function (x) {
                return (n % x) === 0;
            });
        return lows.concat(lows.map(function (x) {
                return n / x;
            })
            .reverse()
            .slice((rRoot === intRoot) | 0));
    }
    function range(m, n, delta) {
        var d = delta || 1,
            blnUp = n > m,
            lng = Math.floor((blnUp ? n - m : m - n) / d) + 1,
            a = Array(lng),
            i = lng;
        if (blnUp)
            while (i--) a[i] = (d * i) + m;
        else
            while (i--) a[i] = m - (d * i);
        return a;
    }
})(100);
