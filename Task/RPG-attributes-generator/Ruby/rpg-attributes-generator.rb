res = []
until res.sum >= 75 && res.count{|n| n >= 15} >= 2 do
  res = Array.new(6) do
    a = Array.new(4){rand(1..6)}
    a.sum - a.min
  end
end

p res
puts "sum: #{res.sum}"
