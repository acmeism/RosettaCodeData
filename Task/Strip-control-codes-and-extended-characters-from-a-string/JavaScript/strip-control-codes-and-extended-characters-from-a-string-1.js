(function (strTest) {

    // s -> s
    function strip(s) {
        return s.split('').filter(function (x) {
            var n = x.charCodeAt(0);

            return 31 < n && 127 > n;
        }).join('');
    }

    return strip(strTest);

})("\ba\x00b\n\rc\fd\xc3");
