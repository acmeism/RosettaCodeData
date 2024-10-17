def semiprime(n)
  nf = 0
  (2..n).each do |i|
    while n % i == 0
      return false if nf == 2
      nf += 1
      n  /= i
    end
  end
  nf == 2
end

(1675..1681).each { |n| puts "#{n} -> #{semiprime(n)}" }
