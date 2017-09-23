(() => {
    // romanValue :: String -> Int
    const romanValue = s =>
        s.length ? (() => {
            const parse = [].concat(
                ...glyphs.map(g => 0 === s.indexOf(g) ? (
                    [dctTrans[g], s.substr(g.length)]
                ) : [])
            );
            return parse[0] + romanValue(parse[1]);
        })() : 0;

    // dctTrans :: {romanKey: Integer}
    const dctTrans = {
        M: 1E3,
        CM: 900,
        D: 500,
        CD: 400,
        C: 100,
        XC: 90,
        L: 50,
        XL: 40,
        X: 10,
        IX: 9,
        V: 5,
        IV: 4,
        I: 1
    };

    // glyphs :: [romanKey]
    const glyphs = Object.keys(dctTrans);

    // TEST -------------------------------------------------------------------
    return ["MCMXC", "MDCLXVI", "MMVIII", "MMMM"].map(romanValue);
})();
