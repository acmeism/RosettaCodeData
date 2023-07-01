def general_fizzbuzz(text)
  num, *nword = text.split
  num = num.to_i
  dict = nword.each_slice(2).map{|n,word| [n.to_i,word]}
  (1..num).each do |i|
    str = dict.map{|n,word| word if i%n==0}.join
    puts str.empty? ? i : str
  end
end

text = <<EOS
20
3 Fizz
5 Buzz
7 Baxx
EOS

general_fizzbuzz(text)
