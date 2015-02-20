bar = ('▁'..'█').to_a
loop {print 'Numbers please separated by space/commas: '
  numbers = gets.split(/[\s,]+/).map(&:to_f)
  min, max = numbers.minmax
  puts "min: %5f; max: %5f"% [min, max]
  div = (max - min) / (bar.size - 1)
  puts min == max ? bar.last*numbers.size : numbers.map{|num| bar[((num - min) / div).to_i]}.join
}
