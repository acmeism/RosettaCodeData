(() => {
    "use strict";

    // -------------- CANTOR RATIONAL PAIRS --------------

    // cantor :: [(Rational, Rational)] ->
    //           [(Rational, Rational)]
    const cantor = xs => {
        const go = ab => {
            const [r1, r2] = Array.from(ab).map(rational);
            const third = ratioDiv(ratioMinus(r2)(r1))(3);

            return [
                Tuple(r1)(ratioPlus(r1)(third)),
                Tuple(ratioMinus(r2)(third))(r2)
            ];
        };

        return xs.flatMap(go);
    };


    // ---------------------- TEST -----------------------
    // main :: IO ()
    const main = () => {
        const
            xs = take(4)(
                iterate(cantor)([Tuple(0)(1)])
            );

        return [
                `${unlines(xs.map(intervalRatios))}\n`,
                intervalBars(xs)
            ]
            .join("\n\n");
    };


    // --------------------- DISPLAY ---------------------

    // intervalRatios :: [(Rational, Rational)] -> String
    const intervalRatios = xs => {
        const go = ab =>
            Array.from(ab).map(
                compose(showRatio, rational)
            )
            .join(", ");

        return `(${xs.map(go).join(") (")})`;
    };

    // intervalBars :: [[(Rational, Rational)]] -> String
    const intervalBars = rs => {
        const go = w => xs =>
            snd(mapAccumL(
                a => ab => {
                    const [wx, wy] = Array.from(ab).map(
                        r => ratioMult(w)(
                            rational(r)
                        )
                    );

                    return Tuple(wy)(
                        replicateString(
                            floor(ratioMinus(wx)(a))
                        )(" ") + replicateString(
                            floor(ratioMinus(wy)(wx))
                        )("█")
                    );
                }
            )(0)(xs)).join("");
        const d = maximum(
            last(rs).map(x => fst(x).d)
        );

        return unlines(rs.map(
            go(Ratio(d)(1))
        ));
    };


    // ---------------- GENERIC FUNCTIONS ----------------

    // Ratio :: Integral a => a -> a -> Ratio a
    const Ratio = a => b => {
        const go = (x, y) =>
            0 !== y ? (() => {
                const d = gcd(x)(y);

                return {
                    type: "Ratio",
                    // numerator
                    "n": Math.trunc(x / d),
                    // denominator
                    "d": Math.trunc(y / d)
                };
            })() : undefined;

        return go(a * signum(b), abs(b));
    };


    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = a =>
        b => ({
            type: "Tuple",
            "0": a,
            "1": b,
            length: 2
        });


    // abs :: Num -> Num
    const abs =
        // Absolute value of a given number
        // without the sign.
        x => 0 > x ? (
            -x
        ) : x;


    // approxRatio :: Float -> Float -> Ratio
    const approxRatio = eps =>
        n => {
            const
                gcde = (e, x, y) => {
                    const _gcd = (a, b) =>
                        b < e ? (
                            a
                        ) : _gcd(b, a % b);

                    return _gcd(Math.abs(x), Math.abs(y));
                },
                c = gcde(Boolean(eps) ? (
                    eps
                ) : (1 / 10000), 1, n);

            return Ratio(
                Math.floor(n / c)
            )(
                Math.floor(1 / c)
            );
        };


    // floor :: Num -> Int
    const floor = x => {
        const
            nr = (
                "Ratio" !== x.type ? (
                    properFraction
                ) : properFracRatio
            )(x),
            n = nr[0];

        return 0 > nr[1] ? n - 1 : n;
    };


    // fst :: (a, b) -> a
    const fst = ab =>
        // First member of a pair.
        ab[0];


    // gcd :: Integral a => a -> a -> a
    const gcd = x =>
        y => {
            const zero = x.constructor(0);
            const go = (a, b) =>
                zero === b ? (
                    a
                ) : go(b, a % b);

            return go(abs(x), abs(y));
        };


    // compose (<<<) :: (b -> c) -> (a -> b) -> a -> c
    const compose = (...fs) =>
        // A function defined by the right-to-left
        // composition of all the functions in fs.
        fs.reduce(
            (f, g) => x => f(g(x)),
            x => x
        );


    // iterate :: (a -> a) -> a -> Gen [a]
    const iterate = f =>
        // An infinite list of repeated
        // applications of f to x.
        function* (x) {
            let v = x;

            while (true) {
                yield v;
                v = f(v);
            }
        };


    // last :: [a] -> a
    const last = xs =>
        // The last item of a list.
        0 < xs.length ? (
            xs.slice(-1)[0]
        ) : null;


    // lcm :: Int -> Int -> Int
    const lcm = x =>
        // The smallest positive integer divisible
        // without remainder by both x and y.
        y => (x === 0 || y === 0) ? (
            0
        ) : Math.abs(Math.floor(x / gcd(x)(y)) * y);


    // mapAccumL :: (acc -> x -> (acc, y)) ->
    // acc -> [x] -> (acc, [y])
    const mapAccumL = f =>
        // A tuple of an accumulation and a list
        // obtained by a combined map and fold,
        // with accumulation from left to right.
        acc => xs => [...xs].reduce(
            (a, x) => {
                const ab = f(a[0])(x);

                return [ab[0], a[1].concat(ab[1])];
            },
            [acc, []]
        );


    // maximum :: Ord a => [a] -> a
    const maximum = xs => (
        // The largest value in a non-empty list.
        ys => 0 < ys.length ? (
            ys.slice(1).reduce(
                (a, y) => y > a ? (
                    y
                ) : a, ys[0]
            )
        ) : undefined
    )(xs);


    // properFracRatio :: Ratio -> (Int, Ratio)
    const properFracRatio = nd => {
        const [q, r] = Array.from(quotRem(nd.n)(nd.d));

        return Tuple(q)(Ratio(r)(nd.d));
    };


    // properFraction :: Real -> (Int, Real)
    const properFraction = n => {
        const i = Math.floor(n) + (n < 0 ? 1 : 0);

        return Tuple(i)(n - i);
    };


    // quotRem :: Integral a => a -> a -> (a, a)
    const quotRem = m =>
        // The quotient, tupled with the remainder.
        n => Tuple(
            Math.trunc(m / n)
        )(
            m % n
        );


    // ratioDiv :: Rational -> Rational -> Rational
    const ratioDiv = n1 => n2 => {
        const [r1, r2] = [n1, n2].map(rational);

        return Ratio(r1.n * r2.d)(
            r1.d * r2.n
        );
    };


    // ratioMinus :: Rational -> Rational -> Rational
    const ratioMinus = n1 => n2 => {
        const [r1, r2] = [n1, n2].map(rational);
        const d = lcm(r1.d)(r2.d);

        return Ratio(
            (r1.n * (d / r1.d)) - (r2.n * (d / r2.d))
        )(d);
    };


    // ratioMult :: Rational -> Rational -> Rational
    const ratioMult = n1 => n2 => {
        const [r1, r2] = [n1, n2].map(rational);

        return Ratio(r1.n * r2.n)(
            r1.d * r2.d
        );
    };


    // ratioPlus :: Rational -> Rational -> Rational
    const ratioPlus = n1 =>
        n2 => {
            const [r1, r2] = [n1, n2].map(rational);
            const d = lcm(r1.d)(r2.d);

            return Ratio(
                (r1.n * (d / r1.d)) + (
                    r2.n * (d / r2.d)
                )
            )(d);
        };


    // rational :: Num a => a -> Rational
    const rational = x =>
        isNaN(x) ? x : Number.isInteger(x) ? (
            Ratio(x)(1)
        ) : approxRatio(undefined)(x);


    // replicateString :: Int -> String -> String
    const replicateString = n =>
        s => s.repeat(n);


    // showRatio :: Ratio -> String
    const showRatio = r =>
        "Ratio" !== r.type ? (
            r.toString()
        ) : r.n.toString() + (
            1 !== r.d ? (
                `/${r.d}`
            ) : ""
        );


    // signum :: Num -> Num
    const signum = n =>
        // | Sign of a number.
        n.constructor(
            0 > n ? (
                -1
            ) : (
                0 < n ? 1 : 0
            )
        );


    // snd :: (a, b) -> b
    const snd = ab =>
        // Second member of a pair.
        ab[1];


    // take :: Int -> [a] -> [a]
    // take :: Int -> String -> String
    const take = n =>
        // The first n elements of a list,
        // string of characters, or stream.
        xs => "GeneratorFunction" !== xs
        .constructor.constructor.name ? (
            xs.slice(0, n)
        ) : [].concat(...Array.from({
            length: n
        }, () => {
            const x = xs.next();

            return x.done ? [] : [x.value];
        }));


    // unlines :: [String] -> String
    const unlines = xs =>
        // A single string formed by the intercalation
        // of a list of strings with the newline character.
        xs.join("\n");


    // MAIN ---
    return main();
})();
