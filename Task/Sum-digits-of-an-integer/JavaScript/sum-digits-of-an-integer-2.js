(function () {
    'use strict';

    // digitsSummed :: (Int | String) -> Int
    function digitsSummed(number) {

        // 10 digits + 26 alphabetics
        // give us glyphs for up to base 36
        var intMaxBase = 36;

        return number
            .toString()
            .split('')
            .reduce(function (a, digit) {
                return a + parseInt(digit, intMaxBase);
            }, 0);
    }

    // TEST

    return [1, 12345, 0xfe, 'fe', 'f0e', '999ABCXYZ']
        .map(function (x) {
            return x + ' -> ' + digitsSummed(x);
        })
        .join('\n');

})();
