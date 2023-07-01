//Find the Digital Root of An Integer - Nigel Galloway: February 1st., 2015
//This code will work with any integer type
let inline digitalRoot N BASE =
  let rec root(p,n) =
    let s = sumDigits n BASE
    if s < BASE then (s,p) else root(p+1, s)
  root(LanguagePrimitives.GenericZero<_> + 1, N)
