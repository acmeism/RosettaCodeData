str = "A man, a plan, a caret, [...2110 chars deleted...] a canal--Panama.".downcase.delete('^a-z')
puts palindrome?(str)    # => true
puts r_palindrome?(str)  # => true

require 'benchmark'
Benchmark.bm do |b|
  b.report('iterative') {10000.times {palindrome?(str)}}
  b.report('recursive') {10000.times {r_palindrome?(str)}}
end
