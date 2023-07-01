def sum35(n)
  (1...n).select{|i|i%3==0 or i%5==0}.sum
end
puts sum35(1000)      #=> 233168
