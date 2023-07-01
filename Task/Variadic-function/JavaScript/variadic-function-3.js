let
  fix = // Variant of the applicative order Y combinator
    f => (f => f(f))(g => f((...a) => g(g)(...a))),
  forAll =
    f =>
      fix(
        z => (a,...b) => (
          (a === void 0)
          ||(f(a), z(...b)))),
  printAll = forAll(print);

printAll(0,1,2,3,4,5);
printAll(6,7,8);
(f => a => f(...a))(printAll)([9,10,11,12,13,14]);
//  0
//  1
//  2
//  3
//  4
//  5
//  6
//  7
//  8
//  9
//  10
//  11
//  12
//  13
//  14
