(() => {
    'use strict';

    // gcd :: Integral a => a -> a -> a
    let gcd = (x, y) => {
        let _gcd = (a, b) => (b === 0 ? a : _gcd(b, a % b)),
            abs = Math.abs;
        return _gcd(abs(x), abs(y));
    }

    // lcm :: Integral a => a -> a -> a
    let lcm = (x, y) =>
        x === 0 || y === 0 ? 0 : Math.abs(Math.floor(x / gcd(x, y)) * y);

    // TEST
    return lcm(12, 18);

})();
