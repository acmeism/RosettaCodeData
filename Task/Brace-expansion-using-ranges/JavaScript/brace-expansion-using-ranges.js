(() => {
    "use strict";

    // -------------- BRACE-RANGE EXPANSION --------------

    // braceExpandWithRange :: String -> [String]
    const braceExpandWithRange = s => {
        // A list containing either the expansions
        // of s, if there are any, or s itself.
        const
            expansions = parse(some(
                braceRangeExpansion()
            ))(s);

        return 0 < expansions.length ? (() => {
            const [parsed, residue] = expansions[0];

            return suffixAdd(
                parsed.reduce(
                    uncurry(suffixMultiply),
                    [""]
                )
            )([residue.join("")]);
        })() : [s];
    };


    // ---------- BRACE-RANGE EXPANSION PARSER -----------

    // braceRangeExpansion :: [String]
    const braceRangeExpansion = () =>
        // List of strings expanded from a
        // a unix shell {<START>..<END>} or
        // {<START>..<END>..<INCR>} expression.
        // See https://wiki.bash-hackers.org/syntax/expansion/brace
        fmapP(([preamble, amble, postscript]) =>
            suffixAdd(
                suffixMultiply(preamble)(amble)
            )(postscript)
        )(sequenceP([
            affixLeaf(),
            fmapP(xs => [xs])(
                between(char("{"))(char("}"))(
                    altP(
                        numericSequence()
                    )(
                        characterSequence()
                    )
                )
            ),
            affixLeaf()
        ]));


    // ---------------------- TESTS ----------------------
    // main :: IO ()
    const main = () => {
        const tests = [
            "simpleNumberRising{1..3}.txt",
            "simpleAlphaDescending-{Z..X}.txt",
            "steppedDownAndPadded-{10..00..5}.txt",
            "minusSignFlipsSequence {030..20..-5}.txt",
            "reverseSteppedNumberRising{1..6..-2}.txt",
            "combined-{Q..P}{2..1}.txt",
            "emoji{🌵..🌶}{🌽..🌾}etc",
            "li{teral",
            "rangeless{}empty",
            "rangeless{random}string"
        ];

        return tests.map(s => {
                const
                    expanded = braceExpandWithRange(s)
                    .join("\n\t");

                return `${s} -> \n\t${expanded}`;
            })
            .join("\n\n");
    };


    // ---------- BRACE-RANGE COMPONENT PARSERS ----------

    // affixLeaf :: () -> Parser String
    const affixLeaf = () =>
        // A sequence of literal (non-syntactic)
        // characters before or after a pair of braces.
        fmapP(cs => [
            [cs.join("")]
        ])(
            many(choice([noneOf("{\\"), escape()]))
        );


    // characterSequence :: () -> Parser [Char]
    const characterSequence = () =>
        // A rising or descending alphabetic
        // sequence of characters.
        fmapP(ab => {
            const [from, to] = ab;

            return from !== to ? (
                enumFromThenToChar(from)(
                    (from < to ? succ : pred)(from)
                )(to)
            ) : [from];
        })(
            ordinalRange(satisfy(
                c => !"0123456789".includes(c)
            ))
        );


    // enumerationList :: ((Bool, String), String) ->
    // ((Bool, String), String) ->
    // ((Bool, String), String) -> [String]
    const enumerationList = triple => {
        // An ordered list of numeric strings either
        // rising or descending, in numeric order, and
        // possibly prefixed with zeros.
        const
            w = padWidth(triple[0][1])(triple[1][1]),
            [from, to, by] = triple.map(
                sn => (sn[0] ? negate : identity)(
                    parseInt(sn[1], 10)
                )
            );

        return map(
            compose(justifyRight(w)("0"), str)
        )(
            (
                0 > by ? (
                    reverse
                ) : identity
            )(
                enumFromThenTo(from)(
                    from + (
                        to < from ? (
                            -abs(by)
                        ) : abs(by)
                    )
                )(to)
            )
        );
    };


    // numericPart :: () -> Parser (Bool, String)
    const numericPart = () =>
        // The Bool is True if the string is
        // negated by a leading '-'
        // The String component contains the digits.
        bindP(
            option("")(char("-"))
        )(sign => bindP(
            some(digit())
        )(ds => pureP(
            Tuple(Boolean(sign))(concat(ds))
        )));


    // numericSequence :: () -> Parser [String]
    const numericSequence = () =>
        // An ascending or descending sequence
        // of numeric strings, possibly
        // left-padded with zeros.
        fmapP(enumerationList)(sequenceP([
            ordinalRange(numericPart()),
            numericStep()
        ]));


    // numericStep :: () -> Parser (Bool, Int)
    const numericStep = () =>
        //  The size of increment for a numeric
        //  series. Descending if the Bool is True.
        //  Defaults to (False, 1).
        option(Tuple(false)(1))(
            bindP(
                string("..")
            )(() => bindP(
                numericPart()
            )(pureP))
        );


    // ordinalRange :: Enum a =>
    // Parser a -> Parser (a, a)
    const ordinalRange = p =>
        // A pair of enumerable values of the same
        // type, representing the start and end of
        // a range.
        bindP(
            p
        )(from => bindP(
            string("..")
        )(() => bindP(
            p
        )(compose(pureP, append([from])))));


    // padWidth :: String -> String -> Int
    const padWidth = cs =>
        // The length of the first of cs and cs1 to
        // start with a zero. Otherwise (if neither
        // starts with a zero) then 0.
        cs1 => [cs, cs1].reduce(
            (a, x) => (0 < a) || (1 > x.length) ? (
                a
            ) : "0" !== x[0] ? a : x.length,
            0
        );


    // suffixAdd :: [String] -> [String] -> [String]
    const suffixAdd = xs =>
        ys => xs.flatMap(
            flip(append)(ys)
        );


    // suffixMultiply :: [String] -> [String] -> [String]
    const suffixMultiply = xs =>
        apList(xs.map(append));


    // ----------- GENERIC PARSER COMBINATORS ------------

    // Parser :: String -> [(a, String)] -> Parser a
    const Parser = f =>
        // A function lifted into a Parser object.
        ({
            type: "Parser",
            parser: f
        });


    // altP (<|>) :: Parser a -> Parser a -> Parser a
    const altP = p =>
        // p, or q if p doesn't match.
        q => Parser(s => {
            const xs = parse(p)(s);

            return 0 < xs.length ? (
                xs
            ) : parse(q)(s);
        });


    // apP <*> :: Parser (a -> b) -> Parser a -> Parser b
    const apP = pf =>
        // A new parser obtained by the application
        // of a Parser-wrapped function,
        // to a Parser-wrapped value.
        p => Parser(
            s => parse(pf)(s).flatMap(
                ([v, r]) => parse(
                    fmapP(v)(p)
                )(r)
            )
        );


    // between :: Parser open -> Parser close ->
    // Parser a -> Parser a
    const between = pOpen =>
        // A version of p which matches between
        // pOpen and pClose (both discarded).
        pClose => p => bindP(
            pOpen
        )(() => bindP(
            p
        )(x => bindP(
            pClose
        )(() => pureP(x))));


    // bindP (>>=) :: Parser a ->
    // (a -> Parser b) -> Parser b
    const bindP = p =>
        // A new parser obtained by the application of
        // a function to a Parser-wrapped value.
        // The function must enrich its output, lifting it
        // into a new Parser.
        // Allows for the nesting of parsers.
        f => Parser(
            s => parse(p)(s).flatMap(
                ([x, r]) => parse(f(x))(r)
            )
        );


    // char :: Char -> Parser Char
    const char = x =>
        // A particular single character.
        satisfy(c => x === c);


    // choice :: [Parser a] -> Parser a
    const choice = ps =>
        // A parser constructed from a
        // (left to right) list of alternatives.
        ps.reduce(uncurry(altP), emptyP());


    // digit :: Parser Char
    const digit = () =>
        // A single digit.
        satisfy(isDigit);


    // emptyP :: () -> Parser a
    const emptyP = () =>
        // The empty list.
        Parser(() => []);


    // escape :: Parser String
    const escape = () =>
        fmapP(xs => xs.join(""))(
            sequenceP([char("\\"), item()])
        );


    // fmapP :: (a -> b) -> Parser a -> Parser b
    const fmapP = f =>
        // A new parser derived by the structure-preserving
        // application of f to the value in p.
        p => Parser(
            s => parse(p)(s).flatMap(
                first(f)
            )
        );


    // item :: () -> Parser Char
    const item = () =>
        // A single character.
        Parser(s => {
            const [h, ...t] = s;

            return Boolean(h) ? [
                Tuple(h)(t)
            ] : [];
        });


    // liftA2P :: (a -> b -> c) ->
    // Parser a -> Parser b -> Parser c
    const liftA2P = op =>
        // The binary function op, lifted
        // to a function over two parsers.
        p => apP(fmapP(op)(p));


    // many :: Parser a -> Parser [a]
    const many = p => {
        // Zero or more instances of p.
        // Lifts a parser for a simple type of value
        // to a parser for a list of such values.
        const someP = q =>
            liftA2P(
                x => xs => [x].concat(xs)
            )(q)(many(q));

        return Parser(
            s => parse(
                0 < s.length ? (
                    altP(someP(p))(pureP([]))
                ) : pureP([])
            )(s)
        );
    };


    // noneOf :: String -> Parser Char
    const noneOf = s =>
        // Any character not found in the
        // exclusion string.
        satisfy(c => !s.includes(c));


    // option :: a -> Parser a -> Parser a
    const option = x =>
        // Either p or the default value x.
        p => altP(p)(pureP(x));


    // parse :: Parser a -> String -> [(a, String)]
    const parse = p =>
        // The result of parsing s with p.
        s => p.parser([...s]);


    // pureP :: a -> Parser a
    const pureP = x =>
        // The value x lifted, unchanged,
        // into the Parser monad.
        Parser(s => [Tuple(x)(s)]);


    // satisfy :: (Char -> Bool) -> Parser Char
    const satisfy = test =>
        // Any character for which the
        // given predicate returns true.
        Parser(s => {
            const [h, ...t] = s;

            return Boolean(h) ? (
                test(h) ? [
                    Tuple(h)(t)
                ] : []
            ) : [];
        });

    // sequenceP :: [Parser a] -> Parser [a]
    const sequenceP = ps =>
        // A single parser for a list of values, derived
        // from a list of parsers for single values.
        Parser(
            s => ps.reduce(
                (a, q) => a.flatMap(
                    ([v, r]) => parse(q)(r).flatMap(
                        first(xs => v.concat(xs))
                    )
                ),
                [Tuple([])(s)]
            )
        );


    // some :: Parser a -> Parser [a]
    const some = p => {
        // One or more instances of p.
        // Lifts a parser for a simple type of value
        // to a parser for a list of such values.
        const manyP = q =>
            altP(some(q))(pureP([]));

        return Parser(
            s => parse(
                liftA2P(
                    x => xs => [x].concat(xs)
                )(p)(manyP(p))
            )(s)
        );
    };


    // string :: String -> Parser String
    const string = s =>
        // A particular string.
        fmapP(cs => cs.join(""))(
            sequenceP([...s].map(char))
        );


    // ---------------- GENERAL FUNCTIONS ----------------

    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = a =>
        b => ({
            type: "Tuple",
            "0": a,
            "1": b,
            length: 2,
            *[Symbol.iterator]() {
                for (const k in this) {
                    if (!isNaN(k)) {
                        yield this[k];
                    }
                }
            }
        });


    // abs :: Num -> Num
    const abs =
        // Absolute value of a given number
        // without the sign.
        x => 0 > x ? (
            -x
        ) : x;


    // apList (<*>) :: [(a -> b)] -> [a] -> [b]
    const apList = fs =>
        // The sequential application of each of a list
        // of functions to each of a list of values.
        // apList([x => 2 * x, x => 20 + x])([1, 2, 3])
        //     -> [2, 4, 6, 21, 22, 23]
        xs => fs.flatMap(f => xs.map(f));


    // append (++) :: [a] -> [a] -> [a]
    const append = xs =>
        // A list obtained by the
        // concatenation of two others.
        ys => xs.concat(ys);


    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (...fs) =>
        // A function defined by the right-to-left
        // composition of all the functions in fs.
        fs.reduce(
            (f, g) => x => f(g(x)),
            x => x
        );


    // concat :: [[a]] -> [a]
    const concat = xs =>
        xs.flat(1);


    // enumFromThenTo :: Int -> Int -> Int -> [Int]
    const enumFromThenTo = m =>
        // Integer values enumerated from m to n
        // with a step defined by (nxt - m).
        nxt => n => {
            const d = nxt - m;

            return Array.from({
                length: (Math.floor(n - nxt) / d) + 2
            }, (_, i) => m + (d * i));
        };


    // enumFromThenToChar :: Char -> Char -> Char -> [Char]
    const enumFromThenToChar = x1 =>
        x2 => y => {
            const [i1, i2, iY] = Array.from([x1, x2, y])
                .map(x => x.codePointAt(0)),
                d = i2 - i1;

            return Array.from({
                length: (Math.floor(iY - i2) / d) + 2
            }, (_, i) => String.fromCodePoint(i1 + (d * i)));
        };


    // first :: (a -> b) -> ((a, c) -> (b, c))
    const first = f =>
        // A simple function lifted to one which applies
        // to a tuple, transforming only its first item.
        ([x, y]) => Tuple(f(x))(y);


    // flip :: (a -> b -> c) -> b -> a -> c
    const flip = op =>
        // The binary function op with
        // its arguments reversed.
        1 < op.length ? (
            (a, b) => op(b, a)
        ) : (x => y => op(y)(x));


    // fromEnum :: Enum a => a -> Int
    const fromEnum = x =>
        typeof x !== "string" ? (
            x.constructor === Object ? (
                x.value
            ) : parseInt(Number(x), 10)
        ) : x.codePointAt(0);


    // identity :: a -> a
    const identity = x =>
        // The identity function. (`id`, in Haskell)
        x;


    // isDigit :: Char -> Bool
    const isDigit = c => {
        const n = c.codePointAt(0);

        return 48 <= n && 57 >= n;
    };


    // justifyRight :: Int -> Char -> String -> String
    const justifyRight = n =>
        // The string s, preceded by enough padding (with
        // the character c) to reach the string length n.
        c => s => n > s.length ? (
            s.padStart(n, c)
        ) : s;


    // map :: (a -> b) -> [a] -> [b]
    const map = f =>
        // The list obtained by applying f
        // to each element of xs.
        // (The image of xs under f).
        xs => [...xs].map(f);


    // maxBound :: a -> a
    const maxBound = x => {
        const e = x.enum;

        return Boolean(e) ? (
            e[e[x.max]]
        ) : {
            "number": Number.MAX_SAFE_INTEGER,
            "string": String.fromCodePoint(0x10FFFF),
            "boolean": true
        } [typeof x];
    };

    // minBound :: a -> a
    const minBound = x => {
        const e = x.enum;

        return Boolean(e) ? (
            e[e[0]]
        ) : {
            "number": Number.MIN_SAFE_INTEGER,
            "string": String.fromCodePoint(0),
            "boolean": false
        } [typeof x];
    };


    // negate :: Num -> Num
    const negate = n =>
        -n;


    // pred :: Enum a => a -> a
    const pred = x => {
        const t = typeof x;

        return "number" !== t ? (() => {
            const [i, mn] = [x, minBound(x)].map(fromEnum);

            return i > mn ? (
                toEnum(x)(i - 1)
            ) : Error("succ :: enum out of range.");
        })() : x > Number.MIN_SAFE_INTEGER ? (
            x - 1
        ) : Error("succ :: Num out of range.");
    };


    // reverse :: [a] -> [a]
    const reverse = xs =>
        xs.slice(0).reverse();


    // str :: a -> String
    const str = x =>
        Array.isArray(x) && x.every(
            v => ("string" === typeof v) && (1 === v.length)
        ) ? (
            x.join("")
        ) : x.toString();


    // succ :: Enum a => a -> a
    const succ = x => {
        const t = typeof x;

        return "number" !== t ? (
            (() => {
                const [i, mx] = [x, maxBound(x)].map(
                    fromEnum
                );

                return i < mx ? (
                    toEnum(x)(1 + i)
                ) : Error("succ :: enum out of range.");
            })()
        ) : x < Number.MAX_SAFE_INTEGER ? (
            1 + x
        ) : Error("succ :: Num out of range.");
    };


    // toEnum :: a -> Int -> a
    const toEnum = e =>
        // The first argument is a sample of the type
        // allowing the function to make the right mapping
        x => ({
            "number": Number,
            "string": String.fromCodePoint,
            "boolean": Boolean,
            "object": v => e.min + v
        } [typeof e])(x);


    // uncurry :: (a -> b -> c) -> ((a, b) -> c)
    const uncurry = f =>
        // A function over a pair, derived
        // from a curried function.
        (...args) => {
            const
                xy = Boolean(args.length % 2) ? (
                    args[0]
                ) : args;

            return f(xy[0])(xy[1]);
        };

    // MAIN ---
    return main();
})();
