((() => {

    // tokenize :: String -> Character -> Character -> [String]
    const tokenize = (charDelim, charEsc, str) => {
        const [token, list, _] = str.split('')
            .reduce(([aToken, aList, aEsc], x) => {
                const
                    blnBreak = !aEsc && x === charDelim,
                    blnEscChar = !aEsc && x === charEsc;

                return [
                    blnBreak ? '' : (
                        aToken + (blnEscChar ? '' : x)
                    ),
                    aList.concat(blnBreak ? aToken : []),
                    blnEscChar
                ];
            }, ['', [], false]);

        return list.concat(token);
    };

    // splitEsc :: String -> [String]
    const splitEsc = str => tokenize('|', '^', str);


    // TEST
    // show :: a -> String
    const show = x => JSON.stringify(x, null, 2);

    return splitEsc(
            'one^|uno||three^^^^|four^^^|^cuatro|',
        )
        .map(show)
        .join('\n');
}))();
