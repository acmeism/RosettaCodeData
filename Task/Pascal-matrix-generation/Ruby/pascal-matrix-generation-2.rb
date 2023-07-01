require 'pp'

def binomial_coeff(n,k) (1..k).inject(1){|res,i| res * (n-i+1) / i}             end

def pascal_upper(n)     (0...n).map{|i| (0...n).map{|j| binomial_coeff(j,i)}}   end
def pascal_lower(n)     (0...n).map{|i| (0...n).map{|j| binomial_coeff(i,j)}}   end
def pascal_symmetric(n) (0...n).map{|i| (0...n).map{|j| binomial_coeff(i+j,j)}} end

puts "Pascal upper-triangular matrix:"
pp pascal_upper(5)

puts "\nPascal lower-triangular matrix:"
pp pascal_lower(5)

puts "\nPascal symmetric matrix:"
pp pascal_symmetric(5)
