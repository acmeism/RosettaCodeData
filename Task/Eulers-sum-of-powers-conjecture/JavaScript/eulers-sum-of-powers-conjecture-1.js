var eulers_sum_of_powers = function (iMaxN) {

    var aPow5 = [];
    var oPow5ToN = {};

    for (var iP = 0; iP <= iMaxN; iP++) {
        var iPow5 = Math.pow(iP, 5);
        aPow5.push(iPow5);
        oPow5ToN[iPow5] = iP;
    }

    for (var i0 = 1; i0 <= iMaxN; i0++) {
        for (var i1 = 1; i1 <= i0; i1++) {
            for (var i2 = 1; i2 <= i1; i2++) {
                for (var i3 = 1; i3 <= i2; i3++) {
                    var iPow5Sum = aPow5[i0] + aPow5[i1] + aPow5[i2] + aPow5[i3];
                    if (typeof oPow5ToN[iPow5Sum] != 'undefined') {
                        return {
                            i0: i0,
                            i1: i1,l
                            i2: i2,
                            i3: i3,
                            iSum: oPow5ToN[iPow5Sum]
                        };
                    }
                }
            }
        }
    }

};

var oResult = eulers_sum_of_powers(250);

console.log(oResult.i0 + '^5 + ' + oResult.i1 + '^5 + ' + oResult.i2 +
    '^5 + ' + oResult.i3 + '^5 = ' + oResult.iSum + '^5');
