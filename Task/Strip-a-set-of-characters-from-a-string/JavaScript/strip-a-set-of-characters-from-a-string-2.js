(() => {
    'use strict';

    // stripChars :: String -> String -> String
    const stripChars = (strNeedles, strHayStack) =>
        strHayStack.replace(RegExp(`[${strNeedles}]`, 'g'), '');

    // GENERIC FUNCTION

    // curry :: ((a, b) -> c) -> a -> b -> c
    const curry = f => a => b => f(a, b);

    // TEST FUNCTION

    const noAEI = curry(stripChars)('aeiAEI');

    // TEST
    return noAEI('She was a soul stripper. She took my heart!');

    // 'Sh ws  soul strppr. Sh took my hrt!'
})();
