def sub_palins(num, min_size = 1)
  digits = num.digits.reverse
  res = []
  (min_size..digits.size).each do |sub_num_size|
    digits.each_cons(sub_num_size){|sub|res << sub if sub == sub.reverse }
  end
  res.uniq
end

(100..125).each {|num| puts "#{num}: #{sub_palins(num)}" }

tests = [9, 169, 12769, 1238769, 123498769, 12346098769, 1234572098769,
123456832098769, 12345679432098769, 1234567905432098769, 123456790165432098769,
83071934127905179083, 1320267947849490361205695]
max_size = tests.max.digits.size
puts "\n#{"Number".ljust(max_size)} Has no >= 2 digit palindromes"
tests.each do |num|
  puts "#{num.to_s.ljust(max_size)} #{! sub_palins(num,2).empty?}"
end
