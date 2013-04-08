def entropy2(s)
  s.each_char.group_by(&:to_s).values.map { |x| x.length / s.length.to_f }.reduce(0) { |e, x| e - x*Math.log2(x) }
end
