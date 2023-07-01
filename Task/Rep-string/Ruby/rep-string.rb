ar = %w(1001110011
        1110111011
        0010010010
        1010101010
        1111111111
        0100101101
        0100100
        101
        11
        00
        1)

ar.each do |str|
  rep_pos = (str.size/2).downto(1).find{|pos| str.start_with? str[pos..-1]}
  puts str, rep_pos ? " "*rep_pos + str[0, rep_pos] : "(no repetition)", ""
end
