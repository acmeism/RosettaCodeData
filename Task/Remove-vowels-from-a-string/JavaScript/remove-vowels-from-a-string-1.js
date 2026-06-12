(() => {
    'use strict'

    // Parser :: String -> Parser String
    const purgedText = exclusions =>
        fmapP(concatMap(concat))(
            sepBy(
                some(noneOf(exclusions))
            )(
                some(oneOf(exclusions))
            )
        );

    // ----------------------- TEST ------------------------
    const main = () => {
        const txt = `
            Rosetta Code is a programming chrestomathy site.
            The idea is to present solutions to the same
            task in as many different languages as possible,
            to demonstrate how languages are similar and
            different, and to aid a person with a grounding
            in one approach to a problem in learning another.`

        return fst(parse(
            purgedText('eau')
        )(txt)[0]);
    };


    // ---------------- PARSER COMBINATORS -----------------

    // Parser :: String -> [(a, String)] -> Parser a
    const Parser = f =>
        // A function lifted into a Parser object.
        ({
            type: 'Parser',
            parser: f
        });


    // altP (<|>) :: Parser a -> Parser a -> Parser a
    const altP = p =>
        // p, or q if p doesn't match.
        q => Parser(s => {
            const xs = p.parser(s);
            return 0 < xs.length ? (
                xs
            ) : q.parser(s);
        });


    // apP <*> :: Parser (a -> b) -> Parser a -> Parser b
    const apP = pf =>
        // A new parser obtained by the application
        // of a Parser-wrapped function,
        // to a Parser-wrapped value.
        p => Parser(
            s => pf.parser(s).flatMap(
                vr => fmapP(vr[0])(
                    p
                ).parser(vr[1])
            )
        );


    // bindP (>>=) :: Parser a ->
    // (a -> Parser b) -> Parser b
    const bindP = p =>
        // A new parser obtained by the application of
        // a function to a Parser-wrapped value.
        // The function must enrich its output, lifting it
        // into a new Parser.
        // Allows for the nesting of parsers.
        f => Parser(
            s => p.parser(s).flatMap(
                tpl => f(tpl[0]).parser(tpl[1])
            )
        );


    // fmapP :: (a -> b) -> Parser a -> Parser b
    const fmapP = f =>
        // A new parser derived by the structure-preserving
        // application of f to the value in p.
        p => Parser(
            s => p.parser(s).flatMap(
                vr => Tuple(f(vr[0]))(vr[1])
            )
        );


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
        const some_p = p =>
            liftA2P(
                x => xs => [x].concat(xs)
            )(p)(many(p));
        return Parser(
            s => (
                0 < s.length ? (
                    altP(some_p(p))(pureP([]))
                ) : pureP([])
            ).parser(s)
        );
    };


    // noneOf :: String -> Parser Char
    const noneOf = s =>
        // Any character not found in the
        // exclusion string.
        satisfy(c => !s.includes(c));


    // oneOf :: [Char] -> Parser Char
    const oneOf = s =>
        // One instance of any character found
        // the given string.
        satisfy(c => s.includes(c));


    // parse :: Parser a -> String -> [(a, String)]
    const parse = p =>
        // The result of parsing s with p.
        s => p.parser(s);


    // pureP :: a -> Parser a
    const pureP = x =>
        // The value x lifted, unchanged,
        // into the Parser monad.
        Parser(s => [Tuple(x)(s)]);


    // satisfy :: (Char -> Bool) -> Parser Char
    const satisfy = test =>
        // Any character for which the
        // given predicate returns true.
        Parser(
            s => 0 < s.length ? (
                test(s[0]) ? [
                    Tuple(s[0])(s.slice(1))
                ] : []
            ) : []
        );


    // sepBy :: Parser a -> Parser b -> Parser [a]
    const sepBy = p =>
        // Zero or more occurrences of p, as
        // separated by (discarded) instances of sep.
        sep => altP(
            sepBy1(p)(sep)
        )(
            pureP([])
        );


    // sepBy1 :: Parser a -> Parser b -> Parser [a]
    const sepBy1 = p =>
        // One or more occurrences of p, as
        // separated by (discarded) instances of sep.
        sep => bindP(
            p
        )(x => bindP(
            many(bindP(
                sep
            )(_ => bindP(
                p
            )(pureP))))(
            xs => pureP([x].concat(xs))));


    // some :: Parser a -> Parser [a]
    const some = p => {
        // One or more instances of p.
        // Lifts a parser for a simple type of value
        // to a parser for a list of such values.
        const many_p = p =>
            altP(some(p))(pureP([]));
        return Parser(
            s => liftA2P(
                x => xs => [x].concat(xs)
            )(p)(many_p(p)).parser(s)
        );
    };

    // ----------------- GENERIC FUNCIONS ------------------

    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = a =>
        b => ({
            type: 'Tuple',
            '0': a,
            '1': b,
            length: 2
        });


    // concat :: [[a]] -> [a]
    // concat :: [String] -> String
    const concat = xs => (
        ys => 0 < ys.length ? (
            ys.every(Array.isArray) ? (
                []
            ) : ''
        ).concat(...ys) : ys
    )(xs);


    // concatMap :: (a -> [b]) -> [a] -> [b]
    const concatMap = f =>
        // Where (a -> [b]) returns an Array, this
        // is equivalent to .flatMap, which should be
        // used by default.
        // but if (a -> [b]) returns String rather than [Char],
        // the monoid unit is '' in place of [], and a
        // concatenated string is returned.
        xs => {
            const ys = list(xs).map(f);
            return 0 < ys.length ? (
                ys.some(y => 'string' !== typeof y) ? (
                    []
                ) : ''
            ).concat(...ys) : ys;
        };


    // list :: StringOrArrayLike b => b -> [a]
    const list = xs =>
        // xs itself, if it is an Array,
        // or an Array derived from xs.
        Array.isArray(xs) ? (
            xs
        ) : Array.from(xs || []);


    // map :: (a -> b) -> [a] -> [b]
    const map = f =>
        // The list obtained by applying f
        // to each element of xs.
        // (The image of xs under f).
        xs => [...xs].map(f);


    // fst :: (a, b) -> a
    const fst = tpl =>
        // First member of a pair.
        tpl[0];

    // main ---
    return main();
})();
