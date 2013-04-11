def ints(n:Int):Stream[Int] = Stream.cons(n,ints(n+1))
def sieve(nums:Stream[Int]):Stream[Int] =
    Stream.cons(nums.head, sieve((nums.tail) filter (_%nums.head != 0)))
def primes = sieve(ints(2))

println( primes take 10 toList )
println( primes takeWhile (_<30) toList )
