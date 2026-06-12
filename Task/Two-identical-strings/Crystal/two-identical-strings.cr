(0..1000).each do |i|
  bin = i.to_s(2)
  if bin.size.even?
    half = bin.size // 2
    if bin[0..half-1] == bin[half..]
      print "%3d: %10s\n" % [i, bin]
    end
  end
end
