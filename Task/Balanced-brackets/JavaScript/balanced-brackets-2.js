(() => {
    'use strict';

    // Int -> String
    let randomBrackets = n => range(1, n)
        .map(() => Math.random() < 0.5 ? '[' : ']')
        .join('');

    // imbalance :: String -> Integer
    let imbalance = strBrackets => {

        // iDepth: initial nesting depth (0 = closed)
        // iIndex: starting character position

        // errorIndex :: [Char] -> Int -> Int -> Int
        let errorIndex = (xs, iDepth, iIndex) => {
            if (xs.length > 0) {
                let tail = xs.slice(1),
                    iNext = iDepth + (xs[0] === '[' ? 1 : -1);

                if (iNext < 0) return iIndex; // unmatched closing bracket
                else return tail.length ? errorIndex(
                        tail, iNext, iIndex + 1
                    ) : iNext === 0 ? -1 : iIndex; // balanced ? problem index ?

            } else return iDepth === 0 ? -1 : iIndex;
        };

        return errorIndex(strBrackets.split(''), 0, 0);
    };


    // GENERIC FUNCTION

    // range :: Int -> Int -> [Int]
    let range = (m, n) =>
        Array.from({
            length: Math.floor(n - m) + 1
        }, (_, i) => m + i);

    // TESTING AND FORMATTING OUTPUT

    let lngPairs = 6,
        strPad = Array(lngPairs * 2 + 4)
        .join(' ');

    return range(0, lngPairs)
        .map(n => {
            let w = n * 2,
                s = randomBrackets(w),
                i = imbalance(s),
                blnOK = i === -1;

            return "'" + s + "'" + strPad.slice(w + 2) +
                (blnOK ? 'OK' : 'problem') +
                (blnOK ? '' : '\n' + Array(i + 2)
                    .join(' ') + '^');
        })
        .join('\n');
})();
