(function () {
    'use strict';

    // FLOYD's TRIANGLE -------------------------------------------------------

    // floyd :: Int -> [[Int]]
    function floyd(n) {
        return snd(mapAccumL(function (start, row) {
            return [start + row + 1, enumFromTo(start, start + row)];
        }, 1, enumFromTo(0, n - 1)));
    };

    // showFloyd :: [[Int]] -> String
    function showFloyd(xss) {
        var ws = map(compose([succ, length, show]), last(xss));
        return unlines(map(function (xs) {
            return concat(zipWith(function (w, x) {
                return justifyRight(w, ' ', show(x));
            }, ws, xs));
        }, xss));
    };


    // GENERIC FUNCTIONS ------------------------------------------------------

    // compose :: [(a -> a)] -> (a -> a)
    function compose(fs) {
        return function (x) {
            return fs.reduceRight(function (a, f) {
                return f(a);
            }, x);
        };
    };

    // concat :: [[a]] -> [a] | [String] -> String
    function concat(xs) {
        if (xs.length > 0) {
            var unit = typeof xs[0] === 'string' ? '' : [];
            return unit.concat.apply(unit, xs);
        } else return [];
    };

    // enumFromTo :: Int -> Int -> [Int]
    function enumFromTo(m, n) {
        return Array.from({
            length: Math.floor(n - m) + 1
        }, function (_, i) {
            return m + i;
        });
    };

    // justifyRight :: Int -> Char -> Text -> Text
    function justifyRight(n, cFiller, strText) {
        return n > strText.length ? (cFiller.repeat(n) + strText)
            .slice(-n) : strText;
    };

    // last :: [a] -> a
    function last(xs) {
        return xs.length ? xs.slice(-1)[0] : undefined;
    };

    // length :: [a] -> Int
    function length(xs) {
        return xs.length;
    };

    // map :: (a -> b) -> [a] -> [b]
    function map(f, xs) {
        return xs.map(f);
    };

    // 'The mapAccumL function behaves like a combination of map and foldl;
    // it applies a function to each element of a list, passing an accumulating
    // parameter from left to right, and returning a final value of this
    // accumulator together with the new list.' (See hoogle )

    // mapAccumL :: (acc -> x -> (acc, y)) -> acc -> [x] -> (acc, [y])
    function mapAccumL(f, acc, xs) {
        return xs.reduce(function (a, x) {
            var pair = f(a[0], x);

            return [pair[0], a[1].concat([pair[1]])];
        }, [acc, []]);
    };

    // show ::
    // (a -> String) f,  Num n =>
    // a -> maybe f -> maybe n -> String
    var show = JSON.stringify;

    // snd :: (a, b) -> b
    function snd(tpl) {
        return Array.isArray(tpl) ? tpl[1] : undefined;
    };

    // succ :: Int -> Int
    function succ(x) {
        return x + 1;
    };

    // unlines :: [String] -> String
    function unlines(xs) {
        return xs.join('\n');
    };

    // zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
    function zipWith(f, xs, ys) {
        var ny = ys.length;
        return (xs.length <= ny ? xs : xs.slice(0, ny))
            .map(function (x, i) {
                return f(x, ys[i]);
            });
    };

    // TEST ( n=5 and n=14 rows ) ---------------------------------------------

    return unlines(map(function (n) {
        return showFloyd(floyd(n)) + '\n';
    }, [5, 14]));
})();
