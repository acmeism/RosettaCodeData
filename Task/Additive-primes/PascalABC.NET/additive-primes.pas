## uses School;//поиск аддитивных простых чисел
var AdditivePrimes := Primes(500).Where(n -> n.Digits.Sum.IsPrime).ToArray;
Print('Additive Primes:'); AdditivePrimes.Println;
Println('Additive Primes Count:', AdditivePrimes.Count);
