bar = ('▁'..'█').to_a
loop do
  print "Numbers please separated by space/commas: "
  numbers = gets.not_nil!.split(/[\s,]+/).map(&.to_f)
  min, max = numbers.minmax
  puts "min: %5f; max: %5f" % [min, max]
  div = (max - min) / (bar.size - 1)
  puts min == max ? bar.last.to_s*numbers.size : numbers.map{|num| bar[((num - min) / div).to_i]}.join
end
