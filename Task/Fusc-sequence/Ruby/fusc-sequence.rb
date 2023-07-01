fusc = Enumerator.new do |y|
  y << 0
  y << 1
  arr = [0,1]
  2.step do |n|
    res = n.even? ? arr[n/2] : arr[(n-1)/2] + arr[(n+1)/2]
    y   << res
    arr << res
  end
end

fusc_max_digits = Enumerator.new do |y|
   cur_max, cur_exp = 0, 0
   0.step do |i|
      f = fusc.next
      if f >= cur_max
        cur_exp += 1
        cur_max = 10**cur_exp
        y << [i, f]
      end
   end
end

puts fusc.take(61).join(" ")
fusc_max_digits.take(6).each{|pair| puts "%15s : %s" % pair }
