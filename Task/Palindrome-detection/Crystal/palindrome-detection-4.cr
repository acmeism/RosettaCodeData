require "benchmark"
Benchmark.ips do |x|
  x.report("declarative") { palindrome("hannah") }
  x.report("imperative1") { palindrome_imperative("hannah")}
  x.report("imperative2") { palindrome_2("hannah")}
end
