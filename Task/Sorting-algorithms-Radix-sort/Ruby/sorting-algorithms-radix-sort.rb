class Array
  def radix_sort(base=10)
    ary = dup
    rounds = (Math.log(self.max.abs)/Math.log(base)).ceil
    rounds.times do |i|
      buckets = Hash.new {|h,k| h[k] = []}
      ary.each do |n|
        digit = (n/base**i) % base
        digit = digit + base unless n<0
        buckets[digit] << n
      end
      ary = buckets.values_at(*(0..2*base)).compact.flatten
      p [i, ary] if $DEBUG
    end
    ary
  end
  def radix_sort!(base=10)
    replace radix_sort(base)
  end
end

p [1, 3, 8, 9, 0, 0, 8, 7, 1, 6].radix_sort
p [170, 45, 75, 90, 2, 24, 802, 66].radix_sort
p [170, 45, 75, 90, 2, 24, -802, -66].radix_sort
