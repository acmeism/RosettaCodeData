(() => {
  'use strict';

  // rk4 :: (Double -> Double -> Double) ->
  //          Double -> Double -> Double -> Double
  const rk4 = f => (y, x, dx) => {
    const
      k1 = dx * f(x, y),
      k2 = dx * f(x + dx / 2.0, y + k1 / 2.0),
      k3 = dx * f(x + dx / 2.0, y + k2 / 2.0),
      k4 = dx * f(x + dx, y + k3);
    return y + (k1 + 2.0 * k2 + 2.0 * k3 + k4) / 6.0;
  };

  // rk :: Double -> Double -> Double -> Double
  const rk = rk4((x, y) => x * Math.sqrt(y));

  // actual :: Double -> Double
  const actual = x => (1 / 16) * ((x * x) + 4) * ((x * x) + 4);


  // TEST -------------------------------------------------

  // main :: IO ()
  const main = () => {
    const
      step = 0.1,
      ixs = enumFromTo(0, 100),
      xys = scanl(
        xy => Tuple(
          ((xy[0] * 10) + (step * 10)) / 10, rk(xy[1], xy[0], step)
        ),
        Tuple(0.0, 1.0),
        ixs
      );

    // samples :: [(Double, Double, Double)]
    const samples = concatMap(
      tpl => 0 === tpl[0] % 10 ? (() => {
        const [x, y] = Array.from(tpl[1]);
        return [TupleN(x, y, actual(x) - y)];
      })() : [],
      zip(ixs, xys)
    );

    console.log(
      unlines(map(
        tpl => {
          const [x, y, v] = Array.from(tpl),
            [sn, sm] = splitOn('.', y.toString());
          return unwords([
            'y' + justifyRight(3, ' ', '(' + Math.round(x).toString()) +
            ') =',
            justifyRight(3, ' ', sn) + '.' + justifyLeft(15, ' ', sm || '0'),
            '± ' + v.toExponential()
          ]);
        },
        samples
      ))
    );
  };


  // GENERIC FUNCTIONS ----------------------------

  // Tuple (,) :: a -> b -> (a, b)
  const Tuple = (a, b) => ({
    type: 'Tuple',
    '0': a,
    '1': b,
    length: 2
  });

  // TupleN :: a -> b ...  -> (a, b ... )
  function TupleN() {
    const
      args = Array.from(arguments),
      lng = args.length;
    return lng > 1 ? Object.assign(
      args.reduce((a, x, i) => Object.assign(a, {
        [i]: x
      }), {
        type: 'Tuple' + (2 < lng ? lng.toString() : ''),
        length: lng
      })
    ) : args[0];
  };

  // concatMap :: (a -> [b]) -> [a] -> [b]
  const concatMap = (f, xs) =>
    xs.reduce((a, x) => a.concat(f(x)), []);

  // enumFromTo :: Int -> Int -> [Int]
  const enumFromTo = (m, n) =>
    Array.from({
      length: 1 + n - m
    }, (_, i) => m + i)

  // justifyLeft :: Int -> Char -> String -> String
  const justifyLeft = (n, cFiller, s) =>
    n > s.length ? (
      s.padEnd(n, cFiller)
    ) : s;

  // justifyRight :: Int -> Char -> String -> String
  const justifyRight = (n, cFiller, s) =>
    n > s.length ? (
      s.padStart(n, cFiller)
    ) : s;

  // Returns Infinity over objects without finite length
  // this enables zip and zipWith to choose the shorter
  // argument when one is non-finite, like cycle, repeat etc

  // length :: [a] -> Int
  const length = xs => xs.length || Infinity;

  // map :: (a -> b) -> [a] -> [b]
  const map = (f, xs) => xs.map(f);

  // scanl :: (b -> a -> b) -> b -> [a] -> [b]
  const scanl = (f, startValue, xs) =>
    xs.reduce((a, x) => {
      const v = f(a[0], x);
      return Tuple(v, a[1].concat(v));
    }, Tuple(startValue, [startValue]))[1];

  // splitOn :: String -> String -> [String]
  const splitOn = (pat, src) => src.split(pat);

  // take :: Int -> [a] -> [a]
  // take :: Int -> String -> String
  const take = (n, xs) =>
    xs.constructor.constructor.name !== 'GeneratorFunction' ? (
      xs.slice(0, n)
    ) : [].concat.apply([], Array.from({
      length: n
    }, () => {
      const x = xs.next();
      return x.done ? [] : [x.value];
    }));

  // unlines :: [String] -> String
  const unlines = xs => xs.join('\n');

  // unwords :: [String] -> String
  const unwords = xs => xs.join(' ');

  // Use of `take` and `length` here allows for zipping with non-finite
  // lists - i.e. generators like cycle, repeat, iterate.

  // zip :: [a] -> [b] -> [(a, b)]
  const zip = (xs, ys) => {
    const lng = Math.min(length(xs), length(ys));
    return Infinity !== lng ? (() => {
      const bs = take(lng, ys);
      return take(lng, xs).map((x, i) => Tuple(x, bs[i]));
    })() : zipGen(xs, ys);
  };

  // MAIN ---
  return main();
})();
