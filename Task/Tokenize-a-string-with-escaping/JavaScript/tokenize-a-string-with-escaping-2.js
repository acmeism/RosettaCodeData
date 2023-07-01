(function () {
    'use strict';

    // tokenize :: String -> Character -> Character -> [String]
    function tokenize(str, charDelim, charEsc) {
        var dctParse = str.split('')
            .reduce(function (a, x) {

                var blnEsc = a.esc,
                    blnBreak = !blnEsc && x === charDelim,
                    blnEscChar = !blnEsc && x === charEsc;

                return {
                    esc: blnEscChar,
                    token: blnBreak ? '' : (
                        a.token + (blnEscChar ? '' : x)
                    ),
                    list: a.list.concat(blnBreak ? a.token : [])
                };
            }, {
                esc: false,
                token: '',
                list: []
            });

        return dctParse.list.concat(
            dctParse.token
        );
    }

    return tokenize(
            'one^|uno||three^^^^|four^^^|^cuatro|',
            '|','^'
        )
        .join('\n');

})();
