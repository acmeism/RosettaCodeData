(() => {
  'use strict';

  // main :: IO ()
  const main = () => {

    // rangeMap :: (Num, Num) -> (Num, Num) -> Num -> Num
    const rangeMap = (a, b) => s => {
      const [a1, a2] = a;
      const [b1, b2] = b;
      // Scaling up an order, and then down, to bypass a potential,
      // precision issue with negative numbers.
      return (((((b2 - b1) * (s - a1)) / (a2 - a1)) * 10) + (10 * b1)) / 10;
    };

    const
      mapping = rangeMap([0, 10], [-1, 0]),
      xs = enumFromTo(0, 10),
      ys = map(mapping, xs),
      zs = map(approxRatio(''), ys);


    const formatted = (x, m, r) => {
      const
        fract = showRatio(r),
        [n, d] = splitOn('/', fract);
      return justifyRight(2, ' ', x.toString()) + '  ->  ' +
        justifyRight(4, ' ', m.toString()) + '   =  ' +
        justifyRight(2, ' ', n.toString()) + '/' + d.toString();
    };

    console.log(
      unlines(zipWith3(formatted, xs, ys, zs))
    );
  };


  // GENERIC FUNCTIONS ----------------------------

  // abs :: Num -> Num
  const abs = Math.abs;

  // Epsilon - > Real - > Ratio
  // approxRatio :: Real -> Real -> Ratio
  const approxRatio = eps => n => {
    const
      gcde = (e, x, y) => {
        const _gcd = (a, b) => (b < e ? a : _gcd(b, a % b));
        return _gcd(abs(x), abs(y));
      },
      c = gcde(Boolean(eps) ? eps : (1 / 10000), 1, abs(n)),
      r = ratio(quot(abs(n), c), quot(1, c));
    return {
      type: 'Ratio',
      n: r.n * signum(n),
      d: r.d
    };
  };

  // enumFromTo :: Int -> Int -> [Int]
  const enumFromTo = (m, n) =>
    Array.from({
      length: 1 + n - m
    }, (_, i) => m + i)

  // gcd :: Int -> Int -> Int
  const gcd = (x, y) => {
    const
      _gcd = (a, b) => (0 === b ? a : _gcd(b, a % b)),
      abs = Math.abs;
    return _gcd(abs(x), abs(y));
  };

  // justifyRight :: Int -> Char -> String -> String
  const justifyRight = (n, cFiller, s) =>
    n > s.length ? (
      s.padStart(n, cFiller)
    ) : s;

  // Returns Infinity over objects without finite length
  // this enables zip and zipWith to choose the shorter
  // argument when one is non-finite, like cycle, repeat etc

  // length :: [a] -> Int
  const length = xs => Array.isArray(xs) ? xs.length : Infinity;

  // map :: (a -> b) -> [a] -> [b]
  const map = (f, xs) => xs.map(f);

  // quot :: Int -> Int -> Int
  const quot = (n, m) => Math.floor(n / m);

  // ratio :: Int -> Int -> Ratio Int
  const ratio = (x, y) => {
    const go = (x, y) =>
      0 !== y ? (() => {
        const d = gcd(x, y);
        return {
          type: 'Ratio',
          'n': quot(x, d), // numerator
          'd': quot(y, d) // denominator
        };
      })() : undefined;
    return go(x * signum(y), abs(y));
  };

  // showRatio :: Ratio -> String
  const showRatio = nd =>
    nd.n.toString() + '/' + nd.d.toString();

  // signum :: Num -> Num
  const signum = n => 0 > n ? -1 : (0 < n ? 1 : 0);

  // splitOn :: String -> String -> [String]
  const splitOn = (pat, src) =>
    src.split(pat);

  // unlines :: [String] -> String
  const unlines = xs => xs.join('\n');

  // zipWith3 :: (a -> b -> c -> d) -> [a] -> [b] -> [c] -> [d]
  const zipWith3 = (f, xs, ys, zs) =>
    Array.from({
      length: Math.min(length(xs), length(ys), length(zs))
    }, (_, i) => f(xs[i], ys[i], zs[i]));

  // MAIN ---
  return main();
})();
