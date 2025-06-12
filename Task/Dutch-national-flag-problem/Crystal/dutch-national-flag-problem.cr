enum FlagColor
  Red
  White
  Blue

  def to_s
    ["🔴", "⚪", "🔵"][value]
  end
end

module Indexable
  def sorted?
    (1...size).each do |i|
      if self[i] < self[i-1]
        return false
      end
    end
    true
  end
end

balls = loop do
  arr = Array.new(20) { FlagColor.values.sample }
  break arr unless arr.sorted?
end

puts balls.join
puts "Sorted: #{balls.sorted?}"
puts

balls.sort!

puts balls.join
puts "Sorted: #{balls.sorted?}"
