import "./math" for Int

var numbers1 = [ 5, 45, 23, 21, 67]
var numbers2 = [43, 22, 78, 46, 38]
var numbers3 = [ 9, 98, 12, 54, 53]
var primes   = List.filled(5, 0)
for (n in 0..4) {
    var max = numbers1[n].max(numbers2[n]).max(numbers3[n])
    if (max % 2 == 0) max = max + 1
    while(!Int.isPrime(max)) max = max + 2
    primes[n] = max
}
System.print(primes)
