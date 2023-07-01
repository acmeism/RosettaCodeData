def semiprime(n)
  `factor #{n}`.split.size == 3
end
n = 2**72 - 1   #4722366482869645213695
(n-50..n).each { |n| puts "#{n} -> #{semiprime(n)}" }
