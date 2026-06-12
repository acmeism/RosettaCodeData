> function* gen() { yield 1; yield 2; return 3 }
undefined
> [...gen()]
[ 1, 2 ]
> const iter = gen()
undefined
> iter.next(); iter.next(); iter.next()
{ value: 3, done: true }
