import "/math" for Int
import "/fmt" for Fmt

var c = Int.primeSieve(1e7, false) // need primes up to 10 million here
var safe = List.filled(35, 0)
var count = 0
var i = 3
while (count < 35) {
    if (!c[i] && !c[(i-1)/2]) {
        safe[count] = i
        count = count + 1
    }
    i = i + 2
}
System.print("The first 35 safe primes are:\n%(safe.join(" "))\n")

count = 35
while (i < 1e6) {
   if (!c[i] && !c[(i-1)/2]) count = count + 1
   i = i + 2
}
Fmt.print("The number of safe primes below 1,000,000 is $,d.\n", count)

while (i < 1e7) {
   if (!c[i] && !c[(i-1)/2]) count = count + 1
   i = i + 2
}
Fmt.print("The number of safe primes below 10,000,000 is $,d.\n", count)

var unsafe = List.filled(40, 0)
unsafe[0] = 2
count = 1
i = 3
while (count < 40) {
    if (!c[i] && c[(i-1)/2]) {
        unsafe[count] = i
        count = count + 1
    }
    i = i + 2
}
System.print("The first 40 unsafe primes are:\n%(unsafe.join(" "))\n")

count = 40
while (i < 1e6) {
   if (!c[i] && c[(i-1)/2]) count = count + 1
   i = i + 2
}
Fmt.print("The number of unsafe primes below 1,000,000 is $,d.\n", count)

while (i < 1e7) {
   if (!c[i] && c[(i-1)/2]) count = count + 1
   i = i + 2
}
Fmt.print("The number of unsafe primes below 10,000,000 is $,d.\n", count)
