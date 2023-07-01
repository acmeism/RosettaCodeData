(() => {
    'use strict';

    // sierpinskiCarpet :: Int -> String
    let sierpinskiCarpet = n => {

        // carpet :: Int -> [[String]]
        let carpet = n => {
                let xs = range(0, Math.pow(3, n) - 1);
                return xs.map(x => xs.map(y => inCarpet(x, y)));
            },

            // https://en.wikipedia.org/wiki/Sierpinski_carpet#Construction

            // inCarpet :: Int -> Int -> Bool
            inCarpet = (x, y) =>
                (!x || !y) ? true : !(
                    (x % 3 === 1) &&
                    (y % 3 === 1)
                ) && inCarpet(
                    x / 3 | 0,
                    y / 3 | 0
                );

        return carpet(n)
            .map(line => line.map(bool => bool ? '\u2588' : ' ')
                .join(''))
            .join('\n');
    };

    // GENERIC

    // range :: Int -> Int -> [Int]
    let range = (m, n) =>
            Array.from({
                length: Math.floor(n - m) + 1
            }, (_, i) => m + i);

    // TEST

    return [1, 2, 3]
        .map(sierpinskiCarpet);
})();
