def pascal(n)
  raise ArgumentError, "must be positive." if n < 1
  yield ar = [1]
  (n-1).times do
    ar.unshift(0).push(0) # tack a zero on both ends
    yield ar = ar.each_cons(2).map(&:sum)
  end
end

pascal(8){|row| puts row.join(" ").center(20)}
