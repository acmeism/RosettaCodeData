# Given two integers n1,n2 return sum of multiples upto n3
#
#  Nigel_Galloway
#  August 24th., 2013.
def g(n1, n2, n3)
   g1 = n1*n2
   (1..g1).select{|x| x%n1==0 or x%n2==0}.collect{|x| g2=(n3-x)/g1; (x+g1*g2+x)*(g2+1)}.inject{|sum,x| sum+x}/2
end

puts g(3,5,999)

# For extra credit
puts g(3,5,100000000000000000000-1)
