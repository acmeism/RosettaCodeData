(lstRanges => {

    // charRange :: Char -> Char -> [Char]
    function charRange(cFrom, cTo) {
        let [m, n] = [cFrom, cTo]
        .map(s => s.codePointAt(0));

        return Array.from({
            length: (n - m) + 1
        }, (_, i) => String.fromCodePoint(m + i));
    }



    // TEST
    return lstRanges
        .map(([from, to]) => charRange(from, to).join(' '))
        .join('\n')

})([['a', 'z'], ['א','ת'],['α', 'ω'],['🐐', '🐟']]);
