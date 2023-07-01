(() => {
    'use strict';

    // topNSalariesPerDept :: Int -> [[String]] -> [String]
    const topNSalariesPerDept = (n, records) =>
        foldl(
            (a, k, i) => (a[toLower(k)] = x => x[i], a),
            this,
            head(records)
        ) && map(intercalate(','),
            concatMap(take(n),
                reverse(
                    groupBy(
                        on(same, department),
                        sortBy(
                            flip(
                                mappendComparing([
                                    department,
                                    salary
                                ])
                            ),
                            tail(records)
                        )
                    )
                )
            )
        );

    // GENERIC FUNCTIONS -----------------------------------------------------

    // comparing :: (a -> b) -> (a -> a -> Ordering)
    const comparing = f =>
        (x, y) => {
            const
                a = f(x),
                b = f(y);
            return a < b ? -1 : (a > b ? 1 : 0);
        };

    // concatMap :: (a -> [b]) -> [a] -> [b]
    const concatMap = (f, xs) =>
        xs.length > 0 ? (() => {
            const unit = typeof xs[0] === 'string' ? '' : [];
            return unit.concat.apply(unit, xs.map(f));
        })() : [];

    // curry :: Function -> Function
    const curry = (f, ...args) => {
        const go = xs => xs.length >= f.length ? (f.apply(null, xs)) :
            function () {
                return go(xs.concat(Array.from(arguments)));
            };
        return go([].slice.call(args, 1));
    };

    // flip :: (a -> b -> c) -> b -> a -> c
    const flip = f => (a, b) => f.apply(null, [b, a]);

    // foldl :: (b -> a -> b) -> b -> [a] -> b
    const foldl = (f, a, xs) => xs.reduce(f, a);

    // groupBy :: (a -> a -> Bool) -> [a] -> [[a]]
    const groupBy = (f, xs) => {
        const dct = xs.slice(1)
            .reduce((a, x) => {
                const
                    h = a.active.length > 0 ? a.active[0] : undefined,
                    blnGroup = h !== undefined && f(h, x);
                return {
                    active: blnGroup ? a.active.concat([x]) : [x],
                    sofar: blnGroup ? a.sofar : a.sofar.concat([a.active])
                };
            }, {
                active: xs.length > 0 ? [xs[0]] : [],
                sofar: []
            });
        return dct.sofar.concat(dct.active.length > 0 ? [dct.active] : []);
    };

    // head :: [a] -> a
    const head = xs => xs.length ? xs[0] : undefined;

    // intercalate :: String -> [a] -> String
    const intercalate = curry((s, xs) => xs.join(s));

    // map :: (a -> b) -> [a] -> [b]
    const map = (f, xs) => xs.map(f);

    // mappendComparing :: [(a -> b)] -> (a -> a -> Ordering)
    const mappendComparing = fs => (x, y) =>
        fs.reduce((ord, f) => (ord !== 0) ? (
            ord
        ) : (() => {
            const
                a = f(x),
                b = f(y);
            return a < b ? -1 : a > b ? 1 : 0
        })(), 0);

    // on :: (b -> b -> c) -> (a -> b) -> a -> a -> c
    const on = (f, g) => (a, b) => f(g(a), g(b));

    // reverse :: [a] -> [a]
    const reverse = xs =>
        typeof xs === 'string' ? (
            xs.split('')
            .reverse()
            .join('')
        ) : xs.slice(0)
        .reverse();

    // same :: a -> a -> Bool
    const same = (a, b) => a === b

    // show :: Int -> a -> Indented String
    // show :: a -> String
    const show = (...x) =>
        JSON.stringify.apply(
            null, x.length > 1 ? [x[1], null, x[0]] : x
        );

    // sortBy :: (a -> a -> Ordering) -> [a] -> [a]
    const sortBy = (f, xs) =>
        xs.slice()
        .sort(f);

    // tail :: [a] -> [a]
    const tail = xs => xs.length ? xs.slice(1) : undefined;

    // take :: Int -> [a] -> [a]
    const take = curry((n, xs) => xs.slice(0, n));

    // toLower :: Text -> Text
    const toLower = s => s.toLowerCase();

    // TEST ------------------------------------------------------------------

    const xs = [
        ["Employee Name", "Employee ID", "Salary", "Department"],
        ["Tyler Bennett", "E10297", "32000", "D101"],
        ["John Rappl", "E21437", "47000", "D050"],
        ["George Woltman", "E00127", "53500", "D101"],
        ["Adam Smith", "E63535", "18000", "D202"],
        ["Claire Buckman", "E39876", "27800", "D202"],
        ["David McClellan", "E04242", "41500", "D101"],
        ["Rich Holcomb", "E01234", "49500", "D202"],
        ["Nathan Adams", "E41298", "21900", "D050"],
        ["Richard Potter", "E43128", "15900", "D101"],
        ["David Motsinger", "E27002", "19250", "D202"],
        ["Tim Sampair", "E03033", "27000", "D101"],
        ["Kim Arlich", "E10001", "57000", "D190"],
        ["Timothy Grove", "E16398", "29900", "D190"]
    ];

    return show(2,
        topNSalariesPerDept(3, xs)
    );
})();
