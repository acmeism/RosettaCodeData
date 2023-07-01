nums = [-5, 5]
pows = [2, 3]
nums.product(pows) do |x, p|
  puts "x = #{x} p = #{p}\t-x**p #{-x**p}\t-(x)**p  #{-(x)**p}\t(-x)**p #{ (-x)**p}\t-(x**p)  #{-(x**p)}"
end
