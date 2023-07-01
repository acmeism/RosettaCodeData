TABLE = ("0".."9").chain("A".."Z", %w(* @ #)).zip(0..).to_h

def valid_CUSIP?(str)
  sum = str[0..-2].chars.each_slice(2).sum do |c1,c2|
    TABLE[c1].divmod(10).sum + (TABLE[c2]*2).divmod(10).sum
  end
  str[-1].to_i == (10 - (sum % 10)) % 10
end

CUSIPs = %w(037833100 17275R102 38259P508 594918104 68389X106 68389X105)
CUSIPs.each{|cusip| puts "#{cusip}: #{valid_CUSIP? cusip}"}
