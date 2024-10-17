def range_expand(range)
  range.split(',').flat_map do |part|
    match = /^(-?\d+)-(-?\d+)$/.match(part)
    if match
      (match[1].to_i .. match[2].to_i).to_a
    else
      part.to_i
    end
  end
end

puts range_expand("-6,-3--1,3-5,7-11,14,15,17-20")
