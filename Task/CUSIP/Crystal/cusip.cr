def cusip_check (input)
  return false  unless input.size == 9
  sum = 0
  input.chars.each_with_index do |c, i|
    break if i == 8
    v = case c
        when .ascii_number?    then c.to_i
        when .ascii_uppercase? then c.ord - 'A'.ord + 10
        when '*'               then 36
        when '@'               then 37
        when '#'               then 38
        else return false
        end
    v *= 2 if (i+1).even?

    sum += v // 10 + v % 10
  end
  input[-1].to_i? == (10 - sum % 10) % 10
end

["037833100",
 "17275R102",
 "38259P508",
 "594918104",
 "68389X106",
 "68389X105"].each do |cusip|
  print cusip, ": ", cusip_check(cusip) ? "valid" : "invalid", "\n"
end
