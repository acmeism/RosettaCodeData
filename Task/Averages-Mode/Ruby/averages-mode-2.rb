def one_mode(ary)
  ary.max_by { |x| ary.count(x) }
end
