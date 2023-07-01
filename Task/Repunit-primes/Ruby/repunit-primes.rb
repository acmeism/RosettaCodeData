require 'prime'
require 'gmp'

(2..16).each do |base|
  res = Prime.each(1000).select {|n| GMP::Z(("1" * n).to_i(base)).probab_prime? > 0}
  puts "Base #{base}: #{res.join(" ")}"
end
