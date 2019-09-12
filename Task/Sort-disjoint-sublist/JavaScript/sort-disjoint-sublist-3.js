(() => {
  'use strict';

  // disjointSort :: [Int] -> [Int] -> [Int]
  const disjointSort = (indices, xs) => {
    const
      ks = sort(indices),
      dct = mapFromList(
        zip(ks, sort(map(k => xs[k], ks)))
      );
    return map(
      (x, i) => {
        const v = dct[i.toString()];
        return undefined !== v ? v : x;
      },
      xs
    );
  };

  // main :: IO ()
  const main = () =>
    showLog(
      disjointSort(
        [6, 1, 7],
        [7, 6, 5, 4, 3, 2, 1, 0]
      )
    );

  // GENERIC FUNCTIONS ----------------------------

  // length :: [a] -> Int
  const length = xs => xs.length || Infinity;

  // map :: (a -> b) -> [a] -> [b]
  const map = (f, xs) => xs.map(f);

  // mapFromList :: [(k, v)] -> Dict
  const mapFromList = kvs =>
    kvs.reduce(
      (a, kv) => {
        const k = kv[0];
        return Object.assign(a, {
          [(('string' === typeof k) && k) || showJSON(k)]: kv[1]
        });
      }, {}
    );

  // showJSON :: a -> String
  const showJSON = x => JSON.stringify(x);

  // showLog :: a -> IO ()
  const showLog = (...args) =>
    console.log(
      args
      .map(JSON.stringify)
      .join(' -> ')
    );

  // sort :: Ord a => [a] -> [a]
  const sort = xs => xs.slice()
    .sort((a, b) => a < b ? -1 : (a > b ? 1 : 0));

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

  // Tuple (,) :: a -> b -> (a, b)
  const Tuple = (a, b) => ({
    type: 'Tuple',
    '0': a,
    '1': b,
    length: 2
  });

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
