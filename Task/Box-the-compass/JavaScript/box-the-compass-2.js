(() => {
    'use strict';

    // GENERIC FUNCTIONS

    // toTitle :: String -> String
    let toTitle = s => s.length ? (s[0].toUpperCase() + s.slice(1)) : '';

    // COMPASS DATA AND FUNCTIONS

    // Scale invariant keys for points of the compass
    // (allows us to look up a translation for one scale of compass (32 here)
    // for use in another size of compass (8 or 16 points)
    // (Also semi-serviceable as more or less legible keys without translation)

    // compassKeys :: Int -> [String]
    let compassKeys = depth => {
        let urCompass = ['N', 'S', 'N'],
            subdivision = (compass, n) => n <= 1 ? (
                compass
            ) : subdivision( // Borders between N and S engender E and W.
                // other new boxes concatenate their parent keys.
                compass.reduce((a, x, i, xs) => {
                    if (i > 0) {
                        return (n === depth) ? (
                            a.concat([x === 'N' ? 'W' : 'E'], x)
                        ) : a.concat([xs[i - 1] + x, x]);
                    } else return a.concat(x);
                }, []),
                n - 1
            );
        return subdivision(urCompass, depth)
            .slice(0, -1);
    };

    // https://zh.wikipedia.org/wiki/%E7%BD%97%E7%9B%98%E6%96%B9%E4%BD%8D
    let lstLangs = [{
        'name': 'English',
        expansions: {
            N: 'north',
            S: 'south',
            E: 'east',
            W: 'west',
            b: ' by ',
            '-': '-'
        },
        'N': 'N',
        'NNNE': 'NbE',
        'NNE': 'N-NE',
        'NNENE': 'NEbN',
        'NE': 'NE',
        'NENEE': 'NEbE',
        'NEE': 'E-NE',
        'NEEE': 'EbN',
        'E': 'E',
        'EEES': 'EbS',
        'EES': 'E-SE',
        'EESES': 'SEbE',
        'ES': 'SE',
        'ESESS': 'SEbS',
        'ESS': 'S-SE',
        'ESSS': 'SbE',
        'S': 'S',
        'SSSW': 'SbW',
        'SSW': 'S-SW',
        'SSWSW': 'SWbS',
        'SW': 'SW',
        'SWSWW': 'SWbW',
        'SWW': 'W-SW',
        'SWWW': 'WbS',
        'W': 'W',
        'WWWN': 'WbN',
        'WWN': 'W-NW',
        'WWNWN': 'NWbW',
        'WN': 'NW',
        'WNWNN': 'NWbN',
        'WNN': 'N-NW',
        'WNNN': 'NbW'
    }, {
        'name': 'Chinese',
        'N': '北',
        'NNNE': '北微东',
        'NNE': '东北偏北',
        'NNENE': '东北微北',
        'NE': '东北',
        'NENEE': '东北微东',
        'NEE': '东北偏东',
        'NEEE': '东微北',
        'E': '东',
        'EEES': '东微南',
        'EES': '东南偏东',
        'EESES': '东南微东',
        'ES': '东南',
        'ESESS': '东南微南',
        'ESS': '东南偏南',
        'ESSS': '南微东',
        'S': '南',
        'SSSW': '南微西',
        'SSW': '西南偏南',
        'SSWSW': '西南微南',
        'SW': '西南',
        'SWSWW': '西南微西',
        'SWW': '西南偏西',
        'SWWW': '西微南',
        'W': '西',
        'WWWN': '西微北',
        'WWN': '西北偏西',
        'WWNWN': '西北微西',
        'WN': '西北',
        'WNWNN': '西北微北',
        'WNN': '西北偏北',
        'WNNN': '北微西'
    }];

    // pointIndex :: Int -> Num -> Int
    let pointIndex = (power, degrees) => {
        let nBoxes = (power ? Math.pow(2, power) : 32);
        return Math.ceil(
            (degrees + (360 / (nBoxes * 2))) % 360 * nBoxes / 360
        ) || 1;
    };

    // pointNames :: Int -> Int -> [String]
    let pointNames = (precision, iBox) => {
        let k = compassKeys(precision)[iBox - 1];
        return lstLangs.map(dctLang => {
            let s = dctLang[k] || k, // fallback to key if no translation
                dctEx = dctLang.expansions;

            return dctEx ? toTitle(s.split('')
                    .map(c => dctEx[c])
                    .join(precision > 5 ? ' ' : ''))
                .replace(/  /g, ' ') : s;
        });
    };

    // maximumBy :: (a -> a -> Ordering) -> [a] -> a
    let maximumBy = (f, xs) =>
        xs.reduce((a, x) => a === undefined ? x : (
            f(x, a) > 0 ? x : a
        ), undefined);

    // justifyLeft :: Int -> Char -> Text -> Text
    let justifyLeft = (n, cFiller, strText) =>
        n > strText.length ? (
            (strText + replicate(n, cFiller)
                .join(''))
            .substr(0, n)
        ) : strText;

    // justifyRight :: Int -> Char -> Text -> Text
    let justifyRight = (n, cFiller, strText) =>
        n > strText.length ? (
            (replicate(n, cFiller)
                .join('') + strText)
            .slice(-n)
        ) : strText;

    // replicate :: Int -> a -> [a]
    let replicate = (n, a) => {
        let v = [a],
            o = [];
        if (n < 1) return o;
        while (n > 1) {
            if (n & 1) o = o.concat(v);
            n >>= 1;
            v = v.concat(v);
        }
        return o.concat(v);
    };

    // transpose :: [[a]] -> [[a]]
    let transpose = xs =>
        xs[0].map((_, iCol) => xs.map((row) => row[iCol]));

    // length :: [a] -> Int
    // length :: Text -> Int
    let length = xs => xs.length;

    // compareByLength = (a, a) -> (-1 | 0 | 1)
    let compareByLength = (a, b) => {
        let [na, nb] = [a, b].map(length);
        return na < nb ? -1 : na > nb ? 1 : 0;
    };

    // maxLen :: [String] -> Int
    let maxLen = xs => maximumBy(compareByLength, xs)
        .length;

    // compassTable :: Int -> [Num] -> Maybe String
    let compassTable = (precision, xs) => {
        if (precision < 1) return undefined;
        else {
            let intPad = 2;

            let lstIndex = xs.map(x => pointIndex(precision, x)),
                lstStrIndex = lstIndex.map(x => x.toString()),
                nIndexWidth = maxLen(lstStrIndex),
                colIndex = lstStrIndex.map(
                    x => justifyRight(nIndexWidth, ' ', x)
                );

            let lstAngles = xs.map(x => x.toFixed(2) + '°'),
                nAngleWidth = maxLen(lstAngles) + intPad,
                colAngles = lstAngles.map(x => justifyRight(nAngleWidth, ' ', x));

            let lstTrans = transpose(
                    lstIndex.map(i => pointNames(precision, i))
                ),
                lstTransWidths = lstTrans.map(x => maxLen(x) + 2),
                colsTrans = lstTrans
                .map((lstLang, i) => lstLang
                    .map(x => justifyLeft(lstTransWidths[i], ' ', x))
                );

            return transpose([colIndex]
                    .concat([colAngles], [replicate(lstIndex.length, "  ")])
                    .concat(colsTrans))
                .map(x => x.join(''))
                .join('\n');
        }
    }

    // TEST
    let xs = [0.0, 16.87, 16.88, 33.75, 50.62, 50.63, 67.5, 84.37,
        84.38, 101.25, 118.12, 118.13, 135.0, 151.87, 151.88, 168.75,
        185.62, 185.63, 202.5, 219.37, 219.38, 236.25, 253.12, 253.13,
        270.0, 286.87, 286.88, 303.75, 320.62, 320.63, 337.5, 354.37,
        354.38
    ];

    // If we supply other precisions, like 4 or 6, (2^n -> 16 or 64 boxes)
    // the bearings will be divided amongst smaller or larger numbers of boxes,
    // either using name translations retrieved by the generic hash
    // or using the hash itself (combined with any expansions)
    // to substitute for missing names for very finely divided boxes.

    return compassTable(5, xs); // 2^5 -> 32 boxes
})();
