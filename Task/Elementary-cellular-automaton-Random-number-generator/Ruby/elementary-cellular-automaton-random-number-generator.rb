size = 100
eca = ElemCellAutomat.new("1"+"0"*(size-1), 30)
eca.take(80).map{|line| line[0]}.each_slice(8){|bin| p bin.join.to_i(2)}
