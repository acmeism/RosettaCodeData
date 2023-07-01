require "big"

def g(n1, n2, n3)
   g1 = n1*n2; n3 -= 1
   (1..g1).select{|x| x%n1==0 || x%n2==0}.map{|x| g2=(n3-x)//g1; (x+g1*g2+x)*(g2+1)}.sum // 2
end

puts g(3,5,999)
puts g(3,5,1000)

# For extra credit
puts g(3,5,"100000000000000000000".to_big_i - 1)
puts g(3,5,"100000000000000000000".to_big_i)
