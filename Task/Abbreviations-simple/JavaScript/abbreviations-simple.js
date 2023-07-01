(() => {
    'use strict';

    // withExpansions :: [(String, Int)] -> String -> String
    const withExpansions = tbl => s =>
        unwords(map(expanded(tbl), words(s)));

    // expanded :: [(String, Int)] -> String -> String
    const expanded = tbl => s => {
        const
            lng = s.length,
            u = toUpper(s),
            p = wn => {
                const [w, n] = Array.from(wn);
                return lng >= n && isPrefixOf(u, w);
            }
        return maybe(
            '*error*',
            fst,
            0 < lng ? (
                find(p, tbl)
            ) : Just(Tuple([], 0))
        );
    };

    // cmdsFromString :: String -> [(String, Int)]
    const cmdsFromString = s =>
        fst(foldr(
            (w, a) => {
                const [xs, n] = Array.from(a);
                return isDigit(head(w)) ? (
                    Tuple(xs, parseInt(w, 10))
                ) : Tuple(
                    [Tuple(toUpper(w), n)].concat(xs),
                    0
                );
            },
            Tuple([], 0),
            words(s)
        ));

    // TEST -----------------------------------------------
    const main = () => {

        // table :: [(String, Int)]
        const table = cmdsFromString(
            `add 1  alter 3  backup 2  bottom 1  Cappend 2  change 1
            Schange Cinsert 2  Clast 3 compress 4 copy 2 count 3 Coverlay 3
            cursor 3  delete 3 Cdelete 2  down 1  duplicate 3 xEdit 1 expand 3
            extract 3  find 1 Nfind 2 Nfindup 6 NfUP 3 Cfind 2 findUP 3 fUP 2
            forward 2  get  help 1 hexType 4 input 1 powerInput 3  join 1
            split 2 spltJOIN load locate 1 Clocate 2 lowerCase 3 upperCase 3
            Lprefix 2  macro  merge 2 modify 3 move 2 msg  next 1 overlay 1
            parse preserve 4 purge 3 put putD query 1 quit read recover 3
            refresh renum 3 repeat 3 replace 1 Creplace 2 reset 3 restore 4
            rgtLEFT right 2 left 2  save  set  shift 2  si  sort  sos stack 3
            status 4 top  transfer 3  type 1  up 1`
        );

        return fTable(
            'Abbreviation tests:\n',
            s => "'" + s + "'",
            s => "\n\t'" + s + "'",
            withExpansions(table),
            [
                'riG   rePEAT copies  put mo   rest    types   fup.    6      poweRin',
                ''
            ]
        );
    };

    // GENERIC FUNCTIONS ----------------------------------

    // Just :: a -> Maybe a
    const Just = x => ({
        type: 'Maybe',
        Nothing: false,
        Just: x
    });

    // Nothing :: Maybe a
    const Nothing = () => ({
        type: 'Maybe',
        Nothing: true,
    });

    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = (a, b) => ({
        type: 'Tuple',
        '0': a,
        '1': b,
        length: 2
    });

    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (f, g) => x => f(g(x));

    // find :: (a -> Bool) -> [a] -> Maybe a
    const find = (p, xs) => {
        for (let i = 0, lng = xs.length; i < lng; i++) {
            if (p(xs[i])) return Just(xs[i]);
        }
        return Nothing();
    };

    // flip :: (a -> b -> c) -> b -> a -> c
    const flip = f =>
        1 < f.length ? (
            (a, b) => f(b, a)
        ) : (x => y => f(y)(x));

    // foldl1 :: (a -> a -> a) -> [a] -> a
    const foldl1 = (f, xs) =>
        1 < xs.length ? xs.slice(1)
        .reduce(f, xs[0]) : xs[0];

    // foldr :: (a -> b -> b) -> b -> [a] -> b
    const foldr = (f, a, xs) => xs.reduceRight(flip(f), a);

    // fst :: (a, b) -> a
    const fst = tpl => tpl[0];

    // fTable :: String -> (a -> String) ->
    //                     (b -> String) -> (a -> b) -> [a] -> String
    const fTable = (s, xShow, fxShow, f, xs) => {
        // Heading -> x display function ->
        //           fx display function ->
        //    f -> values -> tabular string
        const
            ys = map(xShow, xs),
            w = maximum(map(length, ys)),
            rows = zipWith(
                (a, b) => justifyRight(w, ' ', a) + ' -> ' + b,
                ys,
                map(compose(fxShow, f), xs)
            );
        return s + '\n' + unlines(rows);
    };

    // head :: [a] -> a
    const head = xs => xs.length ? xs[0] : undefined;

    // isDigit :: Char -> Bool
    const isDigit = c => {
        const n = ord(c);
        return 48 <= n && 57 >= n;
    };

    // isPrefixOf takes two lists or strings and returns
    // true iff the first is a prefix of the second.

    // isPrefixOf :: [a] -> [a] -> Bool
    // isPrefixOf :: String -> String -> Bool
    const isPrefixOf = (xs, ys) => {
        const go = (xs, ys) => {
            const intX = xs.length;
            return 0 < intX ? (
                ys.length >= intX ? xs[0] === ys[0] && go(
                    xs.slice(1), ys.slice(1)
                ) : false
            ) : true;
        };
        return 'string' !== typeof xs ? (
            go(xs, ys)
        ) : ys.startsWith(xs);
    };

    // justifyRight :: Int -> Char -> String -> String
    const justifyRight = (n, cFiller, s) =>
        n > s.length ? (
            s.padStart(n, cFiller)
        ) : s;

    // Returns Infinity over objects without finite length.
    // This enables zip and zipWith to choose the shorter
    // argument when one is non-finite, like cycle, repeat etc

    // length :: [a] -> Int
    const length = xs =>
        (Array.isArray(xs) || 'string' === typeof xs) ? (
            xs.length
        ) : Infinity;

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) =>
        (Array.isArray(xs) ? (
            xs
        ) : xs.split('')).map(f);

    // maximum :: Ord a => [a] -> a
    const maximum = xs =>
        0 < xs.length ? (
            foldl1((a, x) => x > a ? x : a, xs)
        ) : undefined;

    // maybe :: b -> (a -> b) -> Maybe a -> b
    const maybe = (v, f, m) =>
        m.Nothing ? v : f(m.Just);

    // ord :: Char -> Int
    const ord = c => c.codePointAt(0);

    // take :: Int -> [a] -> [a]
    // take :: Int -> String -> String
    const take = (n, xs) =>
        'GeneratorFunction' !== xs.constructor.constructor.name ? (
            xs.slice(0, n)
        ) : [].concat.apply([], Array.from({
            length: n
        }, () => {
            const x = xs.next();
            return x.done ? [] : [x.value];
        }));

    // toUpper :: String -> String
    const toUpper = s => s.toLocaleUpperCase();

    // unlines :: [String] -> String
    const unlines = xs => xs.join('\n');

    // unwords :: [String] -> String
    const unwords = xs => xs.join(' ');

    // words :: String -> [String]
    const words = s => s.split(/\s+/);

    // Use of `take` and `length` here allows zipping with non-finite lists
    // i.e. generators like cycle, repeat, iterate.

    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = (f, xs, ys) => {
        const
            lng = Math.min(length(xs), length(ys)),
            as = take(lng, xs),
            bs = take(lng, ys);
        return Array.from({
            length: lng
        }, (_, i) => f(as[i], bs[i], i));
    };

    // MAIN ---
    return main();
})();
