(() => {
    'use strict';

    // ------ TOKENIZATION OF A STRING WITH ESCAPES ------

    // tokenizedWithEscapes :: Char -> Char ->
    // String -> [String]
    const tokenizedWithEscapes = esc =>
        // A list of tokens in a given string,
        // where the separator character is sep
        // and any character may be escaped by
        // a preceding esc character.
        sep => compose(
            concatMap(fst),
            parse(
                sepBy(
                    takeWhileEscP(esc)(
                        constant(true)
                    )(
                        ne(sep)
                    )
                )(char(sep))
            )
        );

    // ---------------------- TEST -----------------------
    // main :: IO ()
    const main = () =>
        JSON.stringify(
            tokenizedWithEscapes('^')('|')(
                'one^|uno||three^^^^|four^^^|^cuatro|'
            ),
            null, 2
        );
    // -->
    // [
    //     "one|uno",
    //     "",
    //     "three^^",
    //     "four^|cuatro",
    //     ""
    // ]

    // ----------- GENERIC PARSER COMBINATORS ------------

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
            const xs = parse(p)(s);
            return 0 < xs.length ? (
                xs
            ) : parse(q)(s);
        });


    // anyChar :: () -> Parser Char
    const anyChar = () =>
        // A single character.
        Parser(
            s => 0 < s.length ? [
                Tuple(s[0])(
                    s.slice(1)
                )
            ] : []
        );


    // apP <*> :: Parser (a -> b) -> Parser a -> Parser b
    const apP = pf =>
        // A new parser obtained by the application
        // of a Parser-wrapped function,
        // to a Parser-wrapped value.
        p => Parser(
            s => parse(pf)(s).flatMap(
                vr => parse(
                    fmapP(vr[0])(p)
                )(vr[1])
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
            s => parse(p)(s).flatMap(
                tpl => parse(f(tpl[0]))(tpl[1])
            )
        );


    // char :: Char -> Parser Char
    const char = x =>
        // A particular single character.
        satisfy(c => x == c);


    // fmapP :: (a -> b) -> Parser a -> Parser b
    const fmapP = f =>
        // A new parser derived by the structure-preserving
        // application of f to the value in p.
        p => Parser(
            s => parse(p)(s).flatMap(
                first(f)
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
            s => parse(
                0 < s.length ? (
                    altP(some_p(p))(pureP(''))
                ) : pureP('')
            )(s)
        );
    };


    // parse :: Parser a -> String -> [(a, String)]
    const parse = p =>
        // The result of parsing a string with p.
        p.parser;


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
            many(
                thenP(sep)(
                    bindP(p)(pureP)
                )
            )
        )(xs => pureP([x].concat(xs))));


    // takeWhileEscP :: Char -> (Char -> Bool) ->
    // (Char -> Bool) -> Parser Text
    const takeWhileEscP = esc =>
        escTest => test => {
            // Longest prefix, including any escaped
            // characters, in which escTest returns
            // true for all escaped characters, and
            // test returns true for all other chars.
            const plain = takeWhileP(
                c => (esc !== c) && test(c)
            );
            const escaped = thenBindP(
                char(esc)
            )(
                anyChar()
            )(x => bindP(
                plain
            )(
                compose(pureP, cons(x))
            ));
            return bindP(
                plain
            )(x => bindP(
                many(escaped)
            )(xs => pureP(concat([x].concat(xs)))));
        };


    // takeWhileP :: (Char -> Bool) -> Parser String
    const takeWhileP = p =>
        // The largest prefix in which p is
        // true over all the characters.
        Parser(
            compose(
                pureList,
                first(concat),
                span(p)
            )
        );


    // thenBindP :: Parser a -> Parser b ->
    // (b -> Parser c) Parser c
    const thenBindP = o =>
        // A combination of thenP and bindP in which a
        // preliminary  parser consumes text and discards
        // its output, before any output of a subsequent
        // parser is bound.
        p => f => Parser(
            s => parse(o)(s).flatMap(
                vr => parse(p)(vr[1]).flatMap(
                    tpl => parse(f(tpl[0]))(tpl[1])
                )
            )
        );


    // thenP (>>) :: Parser a -> Parser b -> Parser b
    const thenP = o =>
        // A composite parser in which o just consumes text
        // and then p consumes more and returns a value.
        p => Parser(
            s => parse(o)(s).flatMap(
                vr => parse(p)(vr[1])
            )
        );


    // --------------------- GENERIC ---------------------

    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = a =>
        b => ({
            type: 'Tuple',
            '0': a,
            '1': b,
            length: 2
        });


    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (...fs) =>
        // A function defined by the right-to-left
        // composition of all the functions in fs.
        fs.reduce(
            (f, g) => x => f(g(x)),
            x => x
        );


    // concat :: [[a]] -> [a]
    // concat :: [String] -> String
    const concat = xs => (
        ys => 0 < ys.length ? (
            ys.every(Array.isArray) ? (
                []
            ) : ''
        ).concat(...ys) : ys
    )(list(xs));


    // concatMap :: (a -> [b]) -> [a] -> [b]
    const concatMap = f =>
        // List monad bind operator.
        xs => xs.flatMap(f);


    // cons :: a -> [a] -> [a]
    const cons = x =>
        // A list constructed from the item x,
        // followed by the existing list xs.
        xs => Array.isArray(xs) ? (
            [x].concat(xs)
        ) : 'GeneratorFunction' !== xs
        .constructor.constructor.name ? (
            x + xs
        ) : ( // cons(x)(Generator)
            function* () {
                yield x;
                let nxt = xs.next();
                while (!nxt.done) {
                    yield nxt.value;
                    nxt = xs.next();
                }
            }
        )();


    // constant :: a -> b -> a
    const constant = k =>
        _ => k;


    // first :: (a -> b) -> ((a, c) -> (b, c))
    const first = f =>
        // A simple function lifted to one which applies
        // to a tuple, transforming only its first item.
        xy => Tuple(f(xy[0]))(
            xy[1]
        );


    // fst :: (a, b) -> a
    const fst = tpl =>
        // First member of a pair.
        tpl[0];


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


    // ne :: a -> a -> Bool
    const ne = a =>
        b => a !== b;


    // pureList :: a -> [a]
    const pureList = x => [x];


    // span p xs is equivalent to (takeWhile p xs, dropWhile p xs)
    // span :: (a -> Bool) -> [a] -> ([a], [a])
    const span = p =>
        // Longest prefix of xs consisting of elements which
        // all satisfy p, tupled with the remainder of xs.
        xs => {
            const
                ys = 'string' !== typeof xs ? (
                    list(xs)
                ) : xs,
                iLast = ys.length - 1;
            return splitAt(
                until(
                    i => iLast < i || !p(ys[i])
                )(i => 1 + i)(0)
            )(ys);
        };


    // splitAt :: Int -> [a] -> ([a], [a])
    const splitAt = n =>
        xs => Tuple(xs.slice(0, n))(
            xs.slice(n)
        );


    // unlines :: [String] -> String
    const unlines = xs =>
        // A single string formed by the intercalation
        // of a list of strings with the newline character.
        xs.join('\n');


    // until :: (a -> Bool) -> (a -> a) -> a -> a
    const until = p =>
        f => x => {
            let v = x;
            while (!p(v)) v = f(v);
            return v;
        };

    // MAIN ---
    return main();
})();
