(() => {
    'use strict';

    // ----------------- PALINDROME DATES ------------------

    // palindromeDate :: Int -> [String]
    const palindromeDate = year => {
        // Either an empty list, if no palindromic date
        // can be derived from this year, or a list
        // containing a palindromic IS0 8601 date.
        const
            s = year.toString(),
            r = reverse(s),
            iso = [
                s,
                r.slice(0, 2),
                r.slice(2, 4)
            ].join('-');
        return isNaN(new Date(iso)) ? (
            []
        ) : [iso];
    };

    // ----------------------- TEST ------------------------
    const main = () => {
        const
            xs = enumFromTo(2021)(9999).flatMap(
                palindromeDate
            );
        return [
            `Count of palindromic dates [2021..9999]: ${
                xs.length
            }`,
            '',
            `First 15: ${'\n' + xs.slice(0, 15).join('\n')}`,
            '',
            `Last 15: ${'\n' + xs.slice(-15).join('\n')}`
        ].join('\n');
    };

    // ----------------- GENERIC FUNCTIONS -----------------

    // enumFromTo :: Int -> Int -> [Int]
    const enumFromTo = m =>
        n => Array.from({
            length: 1 + n - m
        }, (_, i) => m + i);

    // reverse :: [a] -> [a]
    const reverse = xs =>
        'string' !== typeof xs ? (
            xs.slice(0).reverse()
        ) : xs.split('').reverse().join('');

    // MAIN ---
    return main();
})();
