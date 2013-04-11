require 'benchmark'
require 'mathn'
Benchmark.bm(24) do |x|
  [2**25 - 6, 2**35 - 7].each do |i|
    puts "#{i} = #{prime_factors_faster(i).join(' * ')}"
    x.report("  prime_factors") { prime_factors(i) }
    x.report("  prime_factors_faster") { prime_factors_faster(i) }
    x.report("  Integer#prime_division") { i.prime_division }
  end
end
