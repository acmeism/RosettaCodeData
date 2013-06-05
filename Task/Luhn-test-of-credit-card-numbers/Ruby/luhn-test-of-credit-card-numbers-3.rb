require 'benchmark'

puts "luhn measure: #{Benchmark.measure { 1000000.times { [49927398716, 49927398717, 1234567812345678, 1234567812345670].each { |i| luhn(i) }} }}"
puts "luhn_performance_2_x_faster measure: #{Benchmark.measure { 1000000.times { [49927398716, 49927398717, 1234567812345678, 1234567812345670].each { |i| luhn_perfomance_2_x_faster(i) }} }}"

luhn measure:  24.330000   0.010000  24.340000 ( 24.324950)
luhn_performance_2_x_faster measure:  11.190000   0.010000  11.200000 ( 11.191664)
