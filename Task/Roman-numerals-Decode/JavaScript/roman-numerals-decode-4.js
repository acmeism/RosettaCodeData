(function (lstTest) {

    function romanValue(s) {
        return s.length ? function () {
            var parse = [].concat.apply([], glyphs.map(function (g) {
                return 0 === s.indexOf(g) ? [trans[g], s.substr(g.length)] : [];
            }));
            return parse[0] + romanValue(parse[1]);
        }() : 0;
    }

    var trans = {
            M: 1E3,
            CM: 900,
            D: 500,
            CD: 400,
            C: 100,
            XC: 90,
            L: 50,
            XL: 40,
            X: 10,
            IX: 9,
            V: 5,
            IV: 4,
            I: 1
        },
        glyphs = Object.keys(trans);

    return lstTest.map(romanValue);

})(["MCMXC", "MDCLXVI", "MMVIII", "MMMM"]);
