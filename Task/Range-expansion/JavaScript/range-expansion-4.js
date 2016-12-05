(strTest => {

    // expansion :: String -> [Int]
    let expansion = strExpr =>

        // concat map yields flattened output list
        [].concat.apply([], strExpr.split(',')
            .map(x => x.split('-')
                .reduce((a, s, i, l) =>

                    // negative (after item 0) if preceded by an empty string
                    // (i.e. a hyphen-split artefact, otherwise ignored)
                    s.length ? i ? a.concat(
                        parseInt(l[i - 1].length ? s :
                            '-' + s, 10)
                    ) : [+s] : a, [])

                // two-number lists are interpreted as ranges
            )
            .map(r => r.length > 1 ? range.apply(null, r) : r)),



        // range :: Int -> Int -> Maybe Int -> [Int]
        range = (m, n, step) => {
            let d = (step || 1) * (n >= m ? 1 : -1);

            return Array.from({
                length: Math.floor((n - m) / d) + 1
            }, (_, i) => m + (i * d));
        };



    return expansion(strTest);

})('-6,-3--1,3-5,7-11,14,15,17-20');
