require 'benchmark'
Benchmark.bmbm {|x|
  x.report("eratosthenes") { eratosthenes(1_000_000) }
  x.report("eratosthenes2") { eratosthenes2(1_000_000) }
}
