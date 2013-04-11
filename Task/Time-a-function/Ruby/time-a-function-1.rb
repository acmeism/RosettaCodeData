require 'benchmark'

Benchmark.bm(8) do |x|
  x.report("nothing:")  {  }
  x.report("sum:")  { (1..1_000_000).inject(4) {|sum, x| sum + x} }
end
