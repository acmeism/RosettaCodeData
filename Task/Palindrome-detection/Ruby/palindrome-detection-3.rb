str = "A man, a plan, a caret, [...2110 chars deleted...] a canal--Panama.".downcase.delete('^a-z')
puts is_palindrome(str)    # => true
puts is_palindrome_r(str)  # => true

require 'benchmark'
Benchmark.bm do |b|
  b.report('iterative') {10000.times {is_palindrome(str)}}
  b.report('recursive') {10000.times {is_palindrome_r(str)}}
end
