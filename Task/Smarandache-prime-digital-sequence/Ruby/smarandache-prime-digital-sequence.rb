require "prime"

smarandache = Enumerator.new do|y|
  prime_digits = [2,3,5,7]
  prime_digits.each{|pr| y << pr} # yield the below-tens
  (1..).each do |n|
    prime_digits.repeated_permutation(n).each do |perm|
      c = perm.join.to_i * 10
      y << c + 3 if (c+3).prime?
      y << c + 7 if (c+7).prime?
    end
  end
end

seq = smarandache.take(100)
p seq.first(25)
p seq.last
