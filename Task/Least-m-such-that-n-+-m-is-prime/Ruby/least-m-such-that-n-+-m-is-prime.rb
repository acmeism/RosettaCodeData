require 'openssl'

def next_prime(n) = ((n+1)..).detect{|n| OpenSSL::BN.new(n).prime?}
def fact(n) = (1..n).inject(:*) || 1

enum_diffs = (0..).lazy.map do |n|
  f = fact(n)
  next_prime(f) - f
end

enum_diffs.first(50).each_slice(10){|s| puts "%4d"*s.size % s}
puts "\nFirst m > 1000 is %d at position %d." % enum_diffs.with_index.detect{|d,_id| d>1000}
