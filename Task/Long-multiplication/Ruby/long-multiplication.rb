def longmult(x,y)
  result = [0]
  j = 0
  y.digits.each do |m|
    c = 0
    i = j
    x.digits.each do |d|
      v = result[i]
      result << 0 if v.zero?
      c, v = (v + c + d*m).divmod(10)
      result[i] = v
      i += 1
    end
    result[i] += c
    j += 1
  end
  # calculate the answer from the result array of digits
  result.reverse.inject(0) {|sum, n| 10*sum + n}
end

n=2**64
printf "         %d * %d = %d\n", n, n, n*n
printf "longmult(%d, %d) = %d\n", n, n, longmult(n,n)
