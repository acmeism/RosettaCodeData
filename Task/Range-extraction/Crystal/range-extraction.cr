def range_extract (numbers)
  ranges = [] of {Int32, Int32}
  numbers.each do |n|
    if (curr = ranges[-1]?) && curr.last == n - 1
      ranges[-1] = { curr.first, n }
    else
      ranges << { n, n }
    end
  end
  ranges.map {|start, stop|
    if start == stop
      start.to_s
    elsif stop - start > 1
      "#{start}-#{stop}"
    else
      "#{start},#{stop}"
    end
  }.join ","
end

puts range_extract [0,  1,  2,  4,  6,  7,  8, 11, 12, 14,
                    15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
                    25, 27, 28, 29, 30, 31, 32, 33, 35, 36,
                    37, 38, 39]
