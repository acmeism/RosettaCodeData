def zeckendorf
  return to_enum(__method__) unless block_given?
  x = 0
  loop do
    bin = x.to_s(2)
    yield bin unless bin.include?("11")
    x += 1
  end
end

zeckendorf.take(21).each_with_index{|x,i| puts "%3d: %8s"% [i, x]}
