(() => {
    'use strict';

    // stripChars :: String -> String -> String
    const stripChars = (strNeedles, strHayStack) =>
        strHayStack.split('')
        .filter(x => !elem(x, strNeedles))
        .join('');

    // GENERIC FUNCTIONS

    // elem :: Eq a => a -> [a] -> Bool
    const elem = (x, xs) => xs.indexOf(x) !== -1;

    // curry :: ((a, b) -> c) -> a -> b -> c
    const curry = f => a => b => f(a, b);

    // TEST FUNCTION

    const noAEI = curry(stripChars)('aeiAEI');


    // TEST
    return noAEI('She was a soul stripper. She took my heart!');

    // 'Sh ws  soul strppr. Sh took my hrt!'
})();
