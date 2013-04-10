def median(ary)
  return nil if ary.empty?
  mid, rem = ary.length.divmod(2)
  if rem == 0
    ary.sort[mid-1,2].inject(:+) / 2.0
  else
    ary.sort[mid]
  end
end

p median([])                        # => nil
p median([5,3,4])                   # => 4
p median([5,4,2,3])                 # => 3.5
p median([3,4,1,-8.4,7.2,4,1,1.2])  # => 2.1
