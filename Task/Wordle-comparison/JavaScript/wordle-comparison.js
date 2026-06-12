(() => {
    "use strict";

    // ---------------- WORDLE COMPARISON ----------------

    // wordleScore :: (String, String) -> [Int]
    const wordleScore = (target, guess) => {
        // A sequence of integers scoring characters
        // in the guess:
        // 2 for correct character and position
        // 1 for a character which is elsewhere in the target
        // 0 for for character not seen in the target.
        const [residue, scores] = mapAccumL(green)([])(
            zip([...target])([...guess])
        );

        return mapAccumL(amber)(
            charCounts(residue)
        )(scores)[1];
    };


    // green :: String ->
    // (Char, Char) -> (String, (Char, Int))
    const green = residue =>
        // The existing residue of unmatched characters,
        // tupled with a character score of 2 if the target
        // character and guess character match.
        // Otherwise, a residue (extended by the unmatched
        // character) tupled with a character score of 0.
        ([t, g]) => t === g ? (
            Tuple(residue)(Tuple(g)(2))
        ) : Tuple([t, ...residue])(Tuple(g)(0));


    // amber :: Dict -> (Char, Int) -> (Dict, Int)
    const amber = tally =>
        // An adjusted tally of the counts of unmatched
        // of remaining unmatched characters, tupled with
        // a 1 if the character was in the remaining tally
        // (now decremented) and otherwise a 0.
        ([c, n]) => 2 === n ? (
            Tuple(tally)(2)
        ) : Boolean(tally[c]) ? (
            Tuple(
                adjust(x => x - 1)(c)(tally)
            )(1)
        ) : Tuple(tally)(0);


    // ---------------------- TEST -----------------------
    // main :: IO ()
    const main = () => [
            ["ALLOW", "LOLLY"],
            ["CHANT", "LATTE"],
            ["ROBIN", "ALERT"],
            ["ROBIN", "SONIC"],
            ["ROBIN", "ROBIN"],
            ["BULLY", "LOLLY"],
            ["ADAPT", "SÅLÅD"],
            ["Ukraine", "Ukraíne"],
            ["BBAAB", "BBBBBAA"],
            ["BBAABBB", "AABBBAA"]
        ]
        .map(tg => wordleReport(...tg))
        .join("\n");


    // wordleReport :: (String, String) -> String
    const wordleReport = (target, guess) => {
        // Either a message, if target or guess are other than
        // five characters long, or a color-coded wordle score
        // for each character in the guess.

        const scoreNames = ["gray", "amber", "green"];

        return 5 !== target.length ? (
            `${target}: Expected 5 character target.`
        ) : 5 !== guess.length ? (
            `${guess}: Expected 5 character guess.`
        ) : (() => {
            const scores = wordleScore(target, guess);

            return [
                target, guess, JSON.stringify(scores),
                scores.map(n => scoreNames[n])
                .join(" ")
            ].join(" -> ");
        })();
    };

    // --------------------- GENERIC ---------------------

    // Tuple (,) :: a -> b -> (a, b)
    const Tuple = a =>
        // A pair of values, possibly of
        // different types.
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


    // add (+) :: Num a => a -> a -> a
    const add = a =>
        // Curried addition.
        b => a + b;


    // adjust :: (a -> a) -> Key ->
    // Dict Key a -> Dict Key a
    const adjust = f => k => dict =>
        // The orginal dictionary, unmodified, if k is
        // not an existing key.
        // Otherwise, a new copy in which the existing
        // value of k is updated by application of f.
        k in dict ? (
            Object.assign({}, dict, {
                [k]: f(dict[k])
            })
        ) : dict;


    // charCounts :: String -> Dict Char Int
    const charCounts = cs =>
        // Dictionary of chars, with the
        // frequency of each in cs.
        [...cs].reduce(
            (a, c) => insertWith(add)(c)(
                1
            )(a), {}
        );


    // insertWith :: Ord k => (a -> a -> a) ->
    // k -> a -> Map k a -> Map k a
    const insertWith = f =>
        // A new dictionary updated with a (k, f(v)(x)) pair.
        // Where there is no existing v for k, the supplied
        // x is used directly.
        k => x => dict => Object.assign({},
            dict, {
                [k]: k in dict ? (
                    f(dict[k])(x)
                ) : x
            });


    // mapAccumL :: (acc -> x -> (acc, y)) -> acc ->
    // [x] -> (acc, [y])
    const mapAccumL = f =>
        // A tuple of an accumulation and a list
        // obtained by a combined map and fold,
        // with accumulation from left to right.
        acc => xs => [...xs].reduce(
            ([a, bs], x) => second(
                v => bs.concat(v)
            )(
                f(a)(x)
            ),
            Tuple(acc)([])
        );


    // second :: (a -> b) -> ((c, a) -> (c, b))
    const second = f =>
        // A function over a simple value lifted
        // to a function over a tuple.
        // f (a, b) -> (a, f(b))
        ([x, y]) => Tuple(x)(f(y));


    // zip :: [a] -> [b] -> [(a, b)]
    const zip = xs =>
        // The paired members of xs and ys, up to
        // the length of the shorter of the two lists.
        ys => Array.from({
            length: Math.min(xs.length, ys.length)
        }, (_, i) => Tuple(xs[i])(ys[i]));

    // MAIN ---
    return main();
})();
