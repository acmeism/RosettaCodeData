(function (n) {
    "use strict";
    return perfectSquaresUpTo(100);
    function perfectSquaresUpTo(n) {
        return range(1, Math.floor(Math.sqrt(n)))
            .map(function (x) {
                return x * x;
            });
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
