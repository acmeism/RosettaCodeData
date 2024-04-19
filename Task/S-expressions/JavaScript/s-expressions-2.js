(() => {
    "use strict";

    // ------------------ S-EXPRESSIONS ------------------
    const main = () => {
        const expr = [
            "((data \"quoted data\" 123 4.5)",
            "  (data (!@# (4.5) \"(more\" \"data)\")))"
        ]
        .join("\n");

        const [parse, residue] = parseExpr(
            tokenized(expr)
        );

        return 0 < residue.length
            ? `Unparsed tokens: ${JSON.stringify(residue)}`
            : 0 < parse.length
                ? [
                    JSON.stringify(parse, null, 2),
                    "Reserialized from parse:",
                    parse.map(serialized).join(" ")
                ]
                .join("\n\n")
                : "Could not be parsed";
    };

    // ---------------- EXPRESSION PARSER ----------------

    // parseExpr [String] -> ([Expr], [String])
    const parseExpr = tokens =>
        // A tuple of (parsed trees, residual tokens)
        // derived from a list of tokens.
        until(finished)(readToken)([
            [], tokens
        ]);


    // finished :: ([Expr], [String]) -> Bool
    const finished = ([, tokens]) =>
        // True if no tokens remain, or the next
        // closes a sub-expression.
        0 === tokens.length || ")" === tokens[0];


    // readToken :: ([Expr], [String]) -> ([Expr], [String])
    const readToken = ([xs, tokens]) => {
        // A tuple of enriched expressions and
        // depleted tokens.
        const [token, ...ts] = tokens;

        // An open bracket introduces recursion over
        // a sub-expression to define a sub-list.
        return "(" === token
            ? (() => {
                const [expr, rest] = parseExpr(ts);

                return [xs.concat([expr]), rest.slice(1)];
            })()
            : ")" === token
                ? [xs, token]
                : [xs.concat(atom(token)), ts];
    };

    // ------------------- ATOM PARSER -------------------

    // atom :: String -> Expr
    const atom = s =>
        0 < s.length
            ? isNaN(s)
                ? "\"'".includes(s[0])
                    ? s.slice(1, -1)
                    : {name: s}
                : parseFloat(s, 10)
            : "";


    // ------------------ TOKENIZATION -------------------

    // tokenized :: String -> [String]
    const tokenized = s =>
        // Brackets and quoted or unquoted atomic strings.
        quoteTokens("\"")(s).flatMap(
            segment => "\"" !== segment[0]
                ? segment.replace(/([()])/gu, " $1 ")
                .split(/\s+/u)
                .filter(Boolean)
                : [segment]
        );


    // quoteTokens :: Char -> String -> [String]
    const quoteTokens = q =>
        // Alternating unquoted and quoted segments.
        s => s.split(q).flatMap(
            (k, i) => even(i)
                ? 0 < k.length
                    ? [k]
                    : []
                : [`${q}${k}${q}`]
        );

    // ------------------ SERIALIZATION ------------------

    // serialized :: Expr -> String
    const serialized = e => {
        const t = typeof e;

        return "number" === t
            ? `${e}`
            : "string" === t
                ? `"${e}"`
                : "object" === t
                    ? Array.isArray(e)
                        ? `(${e.map(serialized).join(" ")})`
                        : e.name
                    : "?";
    };


    // --------------------- GENERIC ---------------------

    // even :: Int -> Bool
    const even = n =>
        // True if 2 is a factor of n.
        0 === n % 2;


    // until :: (a -> Bool) -> (a -> a) -> a -> a
    const until = p =>
        // The value resulting from repeated applications
        // of f to the seed value x, terminating when
        // that result returns true for the predicate p.
        f => {
            const go = x =>
                p(x)
                    ? x
                    : go(f(x));

            return go;
        };

    return main();
})();
