(function () {
    'use strict'

    // Index of any closing brace matching the opening
    // brace at iPosn,
    // with the indices of any immediately-enclosed commas.
    function bracePair(tkns, iPosn, iNest, lstCommas) {
        if (iPosn >= tkns.length || iPosn < 0) return null;

        var t = tkns[iPosn],
            n = (t === '{') ? (
                iNest + 1
            ) : (t === '}' ? (
                iNest - 1
            ) : iNest),
            lst = (t === ',' && iNest === 1) ? (
                lstCommas.concat(iPosn)
            ) : lstCommas;

        return n ? bracePair(tkns, iPosn + 1, n, lst) : {
            close: iPosn,
            commas: lst
        };
    }

    // Parse of a SYNTAGM subtree
    function andTree(dctSofar, tkns) {
        if (!tkns.length) return [dctSofar, []];

        var dctParse = dctSofar ? dctSofar : {
                fn: and,
                args: []
            },

            head = tkns[0],
            tail = head ? tkns.slice(1) : [],

            dctBrace = head === '{' ? bracePair(
                tkns, 0, 0, []
            ) : null,

            lstOR = dctBrace && (
                dctBrace.close
            ) && dctBrace.commas.length ? (
                splitAt(dctBrace.close + 1, tkns)
            ) : null;

        return andTree({
            fn: and,
            args: dctParse.args.concat(
                lstOR ? (
                    orTree(dctParse, lstOR[0], dctBrace.commas)
                ) : head
            )
        }, lstOR ? (
            lstOR[1]
        ) : tail);
    }

    // Parse of a PARADIGM subtree
    function orTree(dctSofar, tkns, lstCommas) {
        if (!tkns.length) return [dctSofar, []];
        var iLast = lstCommas.length;

        return {
            fn: or,
            args: splitsAt(
                lstCommas, tkns
            ).map(function (x, i) {
                var ts = x.slice(
                    1, i === iLast ? (
                        -1
                    ) : void 0
                );

                return ts.length ? ts : [''];
            }).map(function (ts) {
                return ts.length > 1 ? (
                    andTree(null, ts)[0]
                ) : ts[0];
            })
        };
    }

    // List of unescaped braces and commas, and remaining strings
    function tokens(str) {
        // Filter function excludes empty splitting artefacts
        var toS = function (x) {
            return x.toString();
        };

        return str.split(/(\\\\)/).filter(toS).reduce(function (a, s) {
            return a.concat(s.charAt(0) === '\\' ? s : s.split(
                /(\\*[{,}])/
            ).filter(toS));
        }, []);
    }

    // PARSE TREE OPERATOR (1 of 2)
    // Each possible head * each possible tail
    function and(args) {
        var lng = args.length,
            head = lng ? args[0] : null,
            lstHead = "string" === typeof head ? (
                [head]
            ) : head;

        return lng ? (
            1 < lng ? lstHead.reduce(function (a, h) {
                return a.concat(
                    and(args.slice(1)).map(function (t) {
                        return h + t;
                    })
                );
            }, []) : lstHead
        ) : [];
    }

    // PARSE TREE OPERATOR (2 of 2)
    // Each option flattened
    function or(args) {
        return args.reduce(function (a, b) {
            return a.concat(b);
        }, []);
    }

    // One list split into two (first sublist length n)
    function splitAt(n, lst) {
        return n < lst.length + 1 ? [
            lst.slice(0, n), lst.slice(n)
        ] : [lst, []];
    }

    // One list split into several (sublist lengths [n])
    function splitsAt(lstN, lst) {
        return lstN.reduceRight(function (a, x) {
            return splitAt(x, a[0]).concat(a.slice(1));
        }, [lst]);
    }

    // Value of the parse tree
    function evaluated(e) {
        return typeof e === 'string' ? e :
            e.fn(e.args.map(evaluated));
    }

    // JSON prettyprint (for parse tree, token list etc)
    function pp(e) {
        return JSON.stringify(e, function (k, v) {
            return typeof v === 'function' ? (
                '[function ' + v.name + ']'
            ) : v;
        }, 2)
    }


    // ----------------------- MAIN ------------------------

    // s -> [s]
    function expansions(s) {
        // BRACE EXPRESSION PARSED
        var dctParse = andTree(null, tokens(s))[0];

        // ABSTRACT SYNTAX TREE LOGGED
        console.log(pp(dctParse));

        // AST EVALUATED TO LIST OF STRINGS
        return evaluated(dctParse);
    }


    // Sample expressions,
    // double-escaped for quotation in source code.
    var lstTests = [
        '~/{Downloads,Pictures}/*.{jpg,gif,png}',
        'It{{em,alic}iz,erat}e{d,}, please.',
        '{,{,gotta have{ ,\\, again\\, }}more }cowbell!',
        '{}} some }{,{\\\\{ edge, edge} \\,}{ cases, {here} \\\\\\\\\\}'
    ];


    // 1. Return each expression with an indented list of its expansions, while
    // 2. logging each parse tree to the console.log() stream

    return lstTests.map(function (s) {
        return s + '\n\n' + expansions(s).map(function (x) {
            return '   ' + x;
        }).join('\n');
    }).join('\n\n');

})();
