//Sum Digits of An Integer - Nigel Galloway: January 31st., 2015
//This code will work with any integer type
let inline sumDigits N BASE =
  let rec sum(g, n) = if n < BASE then n+g else sum(g+n%BASE, n/BASE)
  sum(LanguagePrimitives.GenericZero<_>,N)
