(() => {
    'use strict';

    // cusipValid = Dict Char Int -> String -> Bool
    const cusipValid = charMap => s => {
        const
            ns = fromMaybe([])(
                traverse(flip(lookupDict)(charMap))(
                    chars(s)
                )
            );
        return 9 === ns.length && (
            last(ns) === rem(
                10 - rem(
                    sum(apList(
                        apList([quot, rem])(
                            zipWith(identity)(
                                cycle([identity, x => 2 * x])
                            )(take(8)(ns))
                        )
                    )([10]))
                )(10)
            )(10)
        );
    };

    //----------------------- TEST ------------------------
    // main :: IO ()
    const main = () => {

        // cusipMap :: Dict Char Int
        const cusipMap = dictFromList(
            zip(chars(
                "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ*@#"
            ))(enumFrom(0)));

        console.log(unlines(map(
            apFn(
                s => validity => s + ' -> ' + str(validity)
            )(cusipValid(cusipMap))
        )([
            '037833100',
            '17275R102',
            '38259P508',
            '594918104',
            '68389X106',
            '68389X105'
        ])));
    };


    //----------------- GENERIC FUNCTIONS -----------------

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
    const Tuple = a =>
        b => ({
            type: 'Tuple',
            '0': a,
            '1': b,
            length: 2
        });


    // apFn :: (a -> b -> c) -> (a -> b) -> a -> c
    const apFn = f =>
        // Applicative instance for functions.
        // f(x) applied to g(x).
        g => x => f(x)(
            g(x)
        );


    // apList (<*>) :: [(a -> b)] -> [a] -> [b]
    const apList = fs =>
        // The sequential application of each of a list
        // of functions to each of a list of values.
        xs => fs.flatMap(
            f => xs.map(f)
        );


    // append (++) :: [a] -> [a] -> [a]
    // append (++) :: String -> String -> String
    const append = xs =>
        // A list or string composed by
        // the concatenation of two others.
        ys => xs.concat(ys);


    // chars :: String -> [Char]
    const chars = s =>
        s.split('');


    // cons :: a -> [a] -> [a]
    const cons = x =>
        xs => Array.isArray(xs) ? (
            [x].concat(xs)
        ) : 'GeneratorFunction' !== xs
        .constructor.constructor.name ? (
            x + xs
        ) : ( // cons(x)(Generator)
            function*() {
                yield x;
                let nxt = xs.next()
                while (!nxt.done) {
                    yield nxt.value;
                    nxt = xs.next();
                }
            }
        )();


    // cycle :: [a] -> Generator [a]
    function* cycle(xs) {
        const lng = xs.length;
        let i = 0;
        while (true) {
            yield(xs[i])
            i = (1 + i) % lng;
        }
    }


    // dictFromList :: [(k, v)] -> Dict
    const dictFromList = kvs =>
        Object.fromEntries(kvs);


    // enumFrom :: Enum a => a -> [a]
    function* enumFrom(x) {
        // A non-finite succession of enumerable
        // values, starting with the value x.
        let v = x;
        while (true) {
            yield v;
            v = succ(v);
        }
    }


    // flip :: (a -> b -> c) -> b -> a -> c
    const flip = f =>
        1 < f.length ? (
            (a, b) => f(b, a)
        ) : (x => y => f(y)(x));


    // fromEnum :: Enum a => a -> Int
    const fromEnum = x =>
        typeof x !== 'string' ? (
            x.constructor === Object ? (
                x.value
            ) : parseInt(Number(x))
        ) : x.codePointAt(0);


    // fromMaybe :: a -> Maybe a -> a
    const fromMaybe = def =>
        // A default value if mb is Nothing
        // or the contents of mb.
        mb => mb.Nothing ? def : mb.Just;


    // fst :: (a, b) -> a
    const fst = tpl =>
        // First member of a pair.
        tpl[0];


    // identity :: a -> a
    const identity = x =>
        // The identity function. (`id`, in Haskell)
        x;


    // last :: [a] -> a
    const last = xs =>
        // The last item of a list.
        0 < xs.length ? xs.slice(-1)[0] : undefined;


    // length :: [a] -> Int
    const length = xs =>
        // Returns Infinity over objects without finite
        // length. This enables zip and zipWith to choose
        // the shorter argument when one is non-finite,
        // like cycle, repeat etc
        (Array.isArray(xs) || 'string' === typeof xs) ? (
            xs.length
        ) : Infinity;


    // liftA2 :: (a -> b -> c) -> Maybe a -> Maybe b -> Maybe c
    const liftA2 = f => a => b =>
        a.Nothing ? a : b.Nothing ? b : Just(f(a.Just)(b.Just));


    // lookupDict :: a -> Dict -> Maybe b
    const lookupDict = k => dct => {
        const v = dct[k];
        return undefined !== v ? (
            Just(v)
        ) : Nothing();
    };

    // map :: (a -> b) -> [a] -> [b]
    const map = f =>
        // The list obtained by applying f
        // to each element of xs.
        // (The image of xs under f).
        xs => (
            Array.isArray(xs) ? (
                xs
            ) : xs.split('')
        ).map(f);


    // pureMay :: a -> Maybe a
    const pureMay = x => Just(x);

    // Given a type name string, returns a
    // specialised 'pure', where
    // 'pure' lifts a value into a particular functor.

    // pureT :: String -> f a -> (a -> f a)
    const pureT = t => x =>
        'List' !== t ? (
            'Either' === t ? (
                pureLR(x)
            ) : 'Maybe' === t ? (
                pureMay(x)
            ) : 'Node' === t ? (
                pureTree(x)
            ) : 'Tuple' === t ? (
                pureTuple(x)
            ) : pureList(x)
        ) : pureList(x);


    // pureTuple :: a -> (a, a)
    const pureTuple = x =>
        Tuple('')(x);

    // quot :: Int -> Int -> Int
    const quot = n =>
        m => Math.floor(n / m);

    // rem :: Int -> Int -> Int
    const rem = n => m => n % m;

    // snd :: (a, b) -> b
    const snd = tpl => tpl[1];

    // str :: a -> String
    const str = x =>
        x.toString();

    // succ :: Enum a => a -> a
    const succ = x => {
        const t = typeof x;
        return 'number' !== t ? (() => {
            const [i, mx] = [x, maxBound(x)].map(fromEnum);
            return i < mx ? (
                toEnum(x)(1 + i)
            ) : Error('succ :: enum out of range.')
        })() : x < Number.MAX_SAFE_INTEGER ? (
            1 + x
        ) : Error('succ :: Num out of range.')
    };

    // sum :: [Num] -> Num
    const sum = xs =>
        // The numeric sum of all values in xs.
        xs.reduce((a, x) => a + x, 0);

    // take :: Int -> [a] -> [a]
    // take :: Int -> String -> String
    const take = n =>
        // The first n elements of a list,
        // string of characters, or stream.
        xs => 'GeneratorFunction' !== xs
        .constructor.constructor.name ? (
            xs.slice(0, n)
        ) : [].concat.apply([], Array.from({
            length: n
        }, () => {
            const x = xs.next();
            return x.done ? [] : [x.value];
        }));

    // The first argument is a sample of the type
    // allowing the function to make the right mapping

    // toEnum :: a -> Int -> a
    const toEnum = e => x =>
        ({
            'number': Number,
            'string': String.fromCodePoint,
            'boolean': Boolean,
            'object': v => e.min + v
        } [typeof e])(x);


    // traverse :: (Applicative f) => (a -> f b) -> [a] -> f [b]
    const traverse = f =>
        // Collected results of mapping each element
        // of a structure to an action, and evaluating
        // these actions from left to right.
        xs => 0 < xs.length ? (() => {
            const
                vLast = f(xs.slice(-1)[0]),
                t = vLast.type || 'List';
            return xs.slice(0, -1).reduceRight(
                (ys, x) => liftA2(cons)(f(x))(ys),
                liftA2(cons)(vLast)(pureT(t)([]))
            );
        })() : [
            []
        ];


    // uncons :: [a] -> Maybe (a, [a])
    const uncons = xs => {
        // Just a tuple of the head of xs and its tail,
        // Or Nothing if xs is an empty list.
        const lng = length(xs);
        return (0 < lng) ? (
            Infinity > lng ? (
                Just(Tuple(xs[0])(xs.slice(1))) // Finite list
            ) : (() => {
                const nxt = take(1)(xs);
                return 0 < nxt.length ? (
                    Just(Tuple(nxt[0])(xs))
                ) : Nothing();
            })() // Lazy generator
        ) : Nothing();
    };


    // uncurry :: (a -> b -> c) -> ((a, b) -> c)
    const uncurry = f =>
        // A function over a pair, derived
        // from a curried function.
        x => ((...args) => {
            const
                xy = 1 < args.length ? (
                    args
                ) : args[0];
            return f(xy[0])(xy[1]);
        })(x);


    // unlines :: [String] -> String
    const unlines = xs =>
        // A single string formed by the intercalation
        // of a list of strings with the newline character.
        xs.join('\n');


    // zip :: [a] -> [b] -> [(a, b)]
    const zip = xs =>
        // Use of `take` and `length` here allows for zipping with non-finite
        // lists - i.e. generators like cycle, repeat, iterate.
        ys => {
            const
                lng = Math.min(length(xs), length(ys)),
                vs = take(lng)(ys);
            return take(lng)(xs).map(
                (x, i) => Tuple(x)(vs[i])
            );
        };

    // Use of `take` and `length` here allows zipping with non-finite lists
    // i.e. generators like cycle, repeat, iterate.

    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    const zipWith = f => xs => ys => {
        const lng = Math.min(length(xs), length(ys));
        return Infinity > lng ? (() => {
            const
                as = take(lng)(xs),
                bs = take(lng)(ys);
            return Array.from({
                length: lng
            }, (_, i) => f(as[i])(
                bs[i]
            ));
        })() : zipWithGen(f)(xs)(ys);
    };


    // zipWithGen :: (a -> b -> c) ->
    // Gen [a] -> Gen [b] -> Gen [c]
    const zipWithGen = f => ga => gb => {
        function* go(ma, mb) {
            let
                a = ma,
                b = mb;
            while (!a.Nothing && !b.Nothing) {
                let
                    ta = a.Just,
                    tb = b.Just
                yield(f(fst(ta))(fst(tb)));
                a = uncons(snd(ta));
                b = uncons(snd(tb));
            }
        }
        return go(uncons(ga), uncons(gb));
    };

    // MAIN ---
    return main();
})();
