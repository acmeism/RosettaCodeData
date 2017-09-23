function countcoins(t, o) {
    'use strict';
    var operandsLength = o.length;
    var solutions = 0;

    function permutate(a, x) {

        // base case
        if (a === t) {
            solutions++;
        }

        // recursive case
        else if (a < t) {
            for (var i = 0; i < operandsLength; i++) {
                if (i >= x) {
                    permutate(o[i] + a, i);
                }
            }
        }
    }

    permutate(0, 0);
    return solutions;
}
