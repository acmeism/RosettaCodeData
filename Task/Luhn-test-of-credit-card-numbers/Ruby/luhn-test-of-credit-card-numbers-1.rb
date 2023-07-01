 def luhn_valid?(str)
   str.scan(/\d/).reverse            #using str.to_i.digits fails for cases with leading zeros
      .each_slice(2)
      .sum { |i, k = 0| i.to_i + ((k.to_i)*2).digits.sum }
      .modulo(10).zero?
 end

["49927398716", "49927398717", "1234567812345678", "1234567812345670"].map{ |i| luhn_valid?(i) }
