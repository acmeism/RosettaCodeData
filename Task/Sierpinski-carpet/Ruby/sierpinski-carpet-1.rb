def sierpinski_carpet(n)
  carpet = ["#"]
  n.times do
    carpet = carpet.collect {|x| x + x + x} +
             carpet.collect {|x| x + x.tr("#"," ") + x} +
             carpet.collect {|x| x + x + x}
  end
  carpet
end

4.times{|i| puts "\nN=#{i}", sierpinski_carpet(i)}
