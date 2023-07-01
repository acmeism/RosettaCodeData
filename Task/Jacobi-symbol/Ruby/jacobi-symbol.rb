def jacobi(a, n)
  raise ArgumentError.new "n must b positive and odd" if n < 1 || n.even?
  res = 1
  until (a %= n) == 0
    while a.even?
      a >>= 1
      res = -res if [3, 5].include? n % 8
    end
    a, n = n, a
    res = -res if [a % 4, n % 4] == [3, 3]
  end
  n == 1 ? res : 0
end

puts "Jacobian symbols for jacobi(a, n)"
puts "n\\a  0  1  2  3  4  5  6  7  8  9 10"
puts "------------------------------------"
1.step(to: 17, by: 2) do |n|
   printf("%2d ", n)
   (0..10).each { |a| printf(" % 2d", jacobi(a, n)) }
   puts
end
