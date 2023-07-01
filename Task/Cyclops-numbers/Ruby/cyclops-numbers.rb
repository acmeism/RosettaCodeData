require 'prime'

NONZEROS = %w(1 2 3 4 5 6 7 8 9)

cyclopes = Enumerator.new do |y|
  (0..).each do |n|
    NONZEROS.repeated_permutation(n) do |lside|
      NONZEROS.repeated_permutation(n) do |rside|
        y << (lside.join + "0" + rside.join).to_i
      end
    end
  end
end

prime_cyclopes             = Enumerator.new {|y| cyclopes.each {|c| y << c if c.prime?} }
blind_prime_cyclopes       = Enumerator.new {|y| prime_cyclopes.each {|c| y << c if c.to_s.delete("0").to_i.prime?} }
palindromic_prime_cyclopes = Enumerator.new {|y| prime_cyclopes.each {|c| y << c if c.to_s == c.to_s.reverse} }

n, m = 50, 10_000_000
["cyclopes", "prime cyclopes", "blind prime cyclopes", "palindromic prime cyclopes"].zip(
[cyclopes, prime_cyclopes, blind_prime_cyclopes, palindromic_prime_cyclopes]).each do |name, enum|
  cycl, idx = enum.each_with_index.detect{|n, i| n > m}
  puts "The first #{n} #{name} are: \n#{enum.take(n).to_a}\nFirst #{name} term > #{m}: #{cycl} at index: #{idx}.", ""
end
