def sierpinski_carpet(n)
  carpet = ["#"]
  n.times do
    carpet = carpet.map { |x| x + x + x } +
             carpet.map { |x| x + x.tr("#"," ") + x } +
             carpet.map { |x| x + x + x }
  end
  carpet
end

5.times{ |i| puts "\nN=#{i}"; sierpinski_carpet(i).each { |row| puts row } }
