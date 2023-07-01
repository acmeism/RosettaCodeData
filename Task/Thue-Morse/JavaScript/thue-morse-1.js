(function(steps) {
    'use strict';
    var i, tmp, s1 = '0', s2 = '1';
    for (i = 0; i < steps; i++) {
        tmp = s1;
        s1 += s2;
        s2 += tmp;
    }
    console.log(s1);
})(6);
