(() => {
    'use strict';

    // Simple Soundex or NARA Soundex (if blnNara = true)

    // soundex :: Bool -> String -> String
    const soundex = (blnNara, name) => {

        // code :: Char -> Char
        const code = c => ['AEIOU', 'BFPV', 'CGJKQSXZ', 'DT', 'L', 'MN', 'R', 'HW']
            .reduce((a, x, i) =>
                a ? a : (x.indexOf(c) !== -1 ? i.toString() : a), '');

        // isAlpha :: Char -> Boolean
        const isAlpha = c => {
            const d = c.charCodeAt(0);
            return d > 64 && d < 91;
        };

        const s = name.toUpperCase()
            .split('')
            .filter(isAlpha);

        return (s[0] || '0') +
            s.map(code)
            .join('')
            .replace(/7/g, blnNara ? '' : '7')
            .replace(/(.)\1+/g, '$1')
            .substr(1)
            .replace(/[07]/g, '')
            .concat('000')
            .substr(0, 3);
    };

    // curry :: ((a, b) -> c) -> a -> b -> c
    const curry = f => a => b => f(a, b),
        [simpleSoundex, naraSoundex] = [false, true]
        .map(bln => curry(soundex)(bln));

    // TEST
    return [
        ["Example", "E251"],
        ["Sownteks", "S532"],
        ["Lloyd", "L300"],
        ["12346", "0000"],
        ["4-H", "H000"],
        ["Ashcraft", "A261"],
        ["Ashcroft", "A261"],
        ["auerbach", "A612"],
        ["bar", "B600"],
        ["barre", "B600"],
        ["Baragwanath", "B625"],
        ["Burroughs", "B620"],
        ["Burrows", "B620"],
        ["C.I.A.", "C000"],
        ["coöp", "C100"],
        ["D-day", "D000"],
        ["d jay", "D200"],
        ["de la Rosa", "D462"],
        ["Donnell", "D540"],
        ["Dracula", "D624"],
        ["Drakula", "D624"],
        ["Du Pont", "D153"],
        ["Ekzampul", "E251"],
        ["example", "E251"],
        ["Ellery", "E460"],
        ["Euler", "E460"],
        ["F.B.I.", "F000"],
        ["Gauss", "G200"],
        ["Ghosh", "G200"],
        ["Gutierrez", "G362"],
        ["he", "H000"],
        ["Heilbronn", "H416"],
        ["Hilbert", "H416"],
        ["Jackson", "J250"],
        ["Johnny", "J500"],
        ["Jonny", "J500"],
        ["Kant", "K530"],
        ["Knuth", "K530"],
        ["Ladd", "L300"],
        ["Lloyd", "L300"],
        ["Lee", "L000"],
        ["Lissajous", "L222"],
        ["Lukasiewicz", "L222"],
        ["naïve", "N100"],
        ["Miller", "M460"],
        ["Moses", "M220"],
        ["Moskowitz", "M232"],
        ["Moskovitz", "M213"],
        ["O'Conner", "O256"],
        ["O'Connor", "O256"],
        ["O'Hara", "O600"],
        ["O'Mally", "O540"],
        ["Peters", "P362"],
        ["Peterson", "P362"],
        ["Pfister", "P236"],
        ["R2-D2", "R300"],
        ["rÄ≈sumÅ∙", "R250"],
        ["Robert", "R163"],
        ["Rupert", "R163"],
        ["Rubin", "R150"],
        ["Soundex", "S532"],
        ["sownteks", "S532"],
        ["Swhgler", "S460"],
        ["'til", "T400"],
        ["Tymczak", "T522"],
        ["Uhrbach", "U612"],
        ["Van de Graaff", "V532"],
        ["VanDeusen", "V532"],
        ["Washington", "W252"],
        ["Wheaton", "W350"],
        ["Williams", "W452"],
        ["Woolcock", "W422"]
    ].reduce((a, [name, naraCode]) => {
        const naraTest = naraSoundex(name),
            simpleTest = simpleSoundex(name);

        const logNara = naraTest !== naraCode ? (
                `${name} was ${naraTest} should be ${naraCode}`
            ) : '',
            logDelta = (naraTest !== simpleTest ? (
                `${name} -> NARA: ${naraTest} vs Simple: ${simpleTest}`
            ) : '');

        return logNara.length || logDelta.length ? (
            a + [logNara, logDelta].join('\n')
        ) : a;
    }, '');
})();
