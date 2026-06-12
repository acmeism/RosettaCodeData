nums  =   [1,2,0], [3,4,-1,1], [7,8,9,11,12]
puts nums.map{|ar|(1..).find{|candidate| !ar.include?(candidate) }}.join(", ")
