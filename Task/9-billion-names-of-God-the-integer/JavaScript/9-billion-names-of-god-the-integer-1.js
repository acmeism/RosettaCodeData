(function () {
    var cache = [
        [1]
    ];
//this was never needed.
   /* function PyRange(start, end, step) {
        step = step || 1;
        if (!end) {
            end = start;
            start = 0;
        }
        var arr = [];
        for (var i = start; i < end; i += step) arr.push(i);
        return arr;
    }*/

    function cumu(n) {
        var /*ra = PyRange(cache.length, n + 1),*/ //Seems there is a better version for this
            r, l, x, Aa, Mi;
       // for (ll in ra) { too pythony
       for (l=cache.length;l<n+1;l++) {
            r = [0];
//            l = ra[ll];
//            ran = PyRange(1, l + 1);
//            for (xx in ran) {
            for(x=1;x<l+1;x++){
//                x = ran[xx];
                r.push(r[r.length - 1] + (Aa = cache[l - x < 0 ? cache.length - (l - x) : l - x])[(Mi = Math.min(x, l - x)) < 0 ? Aa.length - Mi : Mi]);
            }
            cache.push(r);
        }
        return cache[n];
    }

    function row(n) {
        var r = cumu(n),
//            rra = PyRange(n),
            leArray = [],
            i;
//        for (ii in rra) {
        for (i=0;i<n;i++) {
//            i = rra[ii];
            leArray.push(r[i + 1] - r[i]);
        }
        return leArray;
    }

    console.log("Rows:");
    for (iterator = 1; iterator < 12; iterator++) {
        console.log(row(iterator));
    }

// PL clearly this was not tested:
//    console.log("Sums")[23, 123, 1234, 12345].foreach(function (a) {
    console.log("Sums");
    [23, 123, 1234, 12345].forEach(function (a) {
        var s = cumu(a);
        console.log(a, s[s.length - 1]);
    });
})()
