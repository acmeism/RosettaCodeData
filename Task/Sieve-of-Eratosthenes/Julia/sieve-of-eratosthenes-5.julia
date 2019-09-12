function bench()
  @time length(Primes(100)) # warm up JIT
#  println(@time count(x->true, Primes(1000000000))) # about 1.5 seconds slower counting over iteration
  println(@time length(Primes(1000000000)))
end
bench()
