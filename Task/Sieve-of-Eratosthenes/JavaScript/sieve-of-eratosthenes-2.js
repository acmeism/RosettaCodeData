function eratosthenes(limit) {
    var prms = [];
    if (limit >= 2) prms = [2];
    if (limit >= 3) {
        var sqrtlmt = (Math.sqrt(limit) - 3) >> 1;
        var lmt = (limit - 3) >> 1;
        var bfsz = (lmt >> 5) + 1
        var buf = [];
        for (var i = 0; i < bfsz; i++)
            buf.push(0);
        for (var i = 0; i <= sqrtlmt; i++)
            if ((buf[i >> 5] & (1 << (i & 31))) == 0) {
                var p = i + i + 3;
                for (var j = (p * p - 3) >> 1; j <= lmt; j += p)
                    buf[j >> 5] |= 1 << (j & 31);
            }
        for (var i = 0; i <= lmt; i++)
            if ((buf[i >> 5] & (1 << (i & 31))) == 0)
                prms.push(i + i + 3);
    }
    return prms;
}
