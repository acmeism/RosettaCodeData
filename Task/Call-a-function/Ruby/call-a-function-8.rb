class Array
  def sum(init=0, &blk)
    if blk
      inject(init){|s, n| s + blk.call(n)}
    else
      inject(init){|s, n| s + n}
    end
  end
end

ary = [1,2,3,4,5]
p ary.sum                               #=> 15
p ary.sum(''){|n| (-n).to_s}            #=> "-1-2-3-4-5"
p (ary.sum do |n| n * n end)            #=> 55
