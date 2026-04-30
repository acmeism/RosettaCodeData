struct Int
  def arith_compo
    return {false, false} unless self > 0
    return {true,  false} if self == 1
    n = self
    sum = n + 1
    count = 2
    i = 2
    loop do
      j = n // i
      break if j < i
      if i * j == n
        sum += i; count += 1
        (sum += j; count += 1) unless i == j
      end
      i += 1
    end
    { sum % count == 0, count > 2 }
  end
end

def arithmetic_numbers
  (1..).each.compact_map {|n|
    arith, compo = n.arith_compo
    if arith
      {n, compo}
    end
  }
end

arithmetic_numbers.first(100).each_slice(20) do |row|
  puts row.map {|n| "%3d" % n }.join(" ")
end

milestones = [1_000, 10_000, 100_000, 1_000_000]

ncompos = 0
arithmetic_numbers.each_with_index do |(n, compo), i|
  ncompos += 1 if compo
  if (i+1).in? milestones
    puts "The #{i+1}th arithmetic number: #{n}"
    puts "   #{ncompos} composite numbers in the first #{i+1} arithmetic numbers."
  end
  break if i > milestones.last
end
