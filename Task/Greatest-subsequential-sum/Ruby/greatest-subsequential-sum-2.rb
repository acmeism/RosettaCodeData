# the trick is that at any point
# in the iteration if starting a new chain is
# better than your current score with this element
# added to it, then do so.
# the interesting part is proving the math behind it
Infinity = 1.0/0
def subarray_sum(arr)
  curr,max = -Infinity,-Infinity
  first,last= 0,0
  arr.each_with_index do |e,i|
    curr = e + curr
    if(e>curr)
      curr = e
      first=i
    end
    if(curr > max)
      max = curr
      last=i
    end
  end
  return max,arr[first...last+1]
end

input=[1,2,3,4,5,-8,-9,-20,40,25,-5]
p subarray_sum(input)
=>[65, [40, 25]]

input=[-3, -1]
p subarray_sum(input)
=>[-1, [-1]]
