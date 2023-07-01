def nthroots(n):
  (8 * (1|atan)) as $twopi
  | range(0;n) | (($twopi * .) / n) as $angle | [ ($angle | cos), ($angle | sin) ];

nthroots(10)
