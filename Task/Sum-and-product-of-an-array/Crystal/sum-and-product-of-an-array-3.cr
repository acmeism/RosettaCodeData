require "benchmark"
Benchmark.ips do |x|
    x.report("declarative") { sum_product [1, 2, 3, 4, 5] }
    x.report("imperative") { sum_product_imperative [1, 2, 3, 4, 5] }
end
