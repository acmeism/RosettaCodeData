struct Int
  def kprime? (k)
    n = self
    nf = 0
    (typeof(n).new(2) .. n).each do |i|
      while n % i == 0
        return false if nf == k
        nf += 1
        n //= i
      end
    end
    nf == k
  end
end

def kprimes (k)
  (2..).each.select &.kprime?(k)
end

(1..5).each do |k|
  print k, ": ", kprimes(k).first(10).to_a, "\n"
end
