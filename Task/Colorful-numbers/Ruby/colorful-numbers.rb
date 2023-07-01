def colorful?(ar)
  products = []
  (1..ar.size).all? do |chunk_size|
    ar.each_cons(chunk_size) do |chunk|
      product = chunk.inject(&:*)
      return false if products.include?(product)
      products << product
    end
  end
end

below100 = (0..100).select{|n| colorful?(n.digits)}
puts "The colorful numbers less than 100 are:", below100.join(" "), ""
puts "Largest colorful number: #{(98765432.downto(1).detect{|n| colorful?(n.digits) })}", ""

total = 0
(1..8).each do |numdigs|
   digits = (numdigs == 1 ? (0..9).to_a : (2..9).to_a)
   count  = digits.permutation(numdigs).count{|perm| colorful?(perm)}
   puts "#{numdigs} digit colorful numbers count: #{count}"
   total += count
end

puts "\nTotal colorful numbers: #{total}"
