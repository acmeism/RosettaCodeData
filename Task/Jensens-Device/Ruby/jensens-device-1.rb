def sum(var, lo, hi, term, context)
  sum = 0.0
  lo.upto(hi) do |n|
    sum += eval "#{var} = #{n}; #{term}", context
  end
  sum
end
p sum "i", 1, 100, "1.0 / i", binding   # => 5.18737751763962
