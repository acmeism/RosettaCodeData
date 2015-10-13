let
  fix = // This is a variant of the Applicative order Y combinator
    f => (f => f(f))(g => f((...a) => g(g)(...a))),
  curry =
    f => (
      fix(
        z => (n,...a) => (
          n>0
          ?b => z(n-1,...a,b)
          :f(...a)))
      (f.length)),
  curryrest =
    f => (
      fix(
        z => (n,...a) => (
          n>0
          ?b => z(n-1,...a,b)
          :(...b) => f(...a,...b)))
      (f.length)),
  curriedmax=curry(Math.max),
  curryrestedmax=curryrest(Math.max);
print(curriedmax(8)(4),curryrestedmax(8)(4)(),curryrestedmax(8)(4)(9,7,2));
// 8,8,9
