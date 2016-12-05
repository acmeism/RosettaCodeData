(() => {
    'use strict';

    // isPangram :: String -> Bool
    let isPangram = s => {
        let lc = s.toLowerCase();

        return 'abcdefghijklmnopqrstuvwxyz'
            .split('')
            .filter(c => lc.indexOf(c) === -1)
            .length === 0;
    };

    // TEST
    return [
        'is this a pangram',
        'The quick brown fox jumps over the lazy dog'
    ].map(isPangram);

})();
