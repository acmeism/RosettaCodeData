def letter_frequency(file)
  letters = 'a' .. 'z'
  File.read(file) .
       split(//) .
       group_by {|letter| letter.downcase} .
       select   {|key, val| letters.include? key} .
       collect  {|key, val| [key, val.length]}
end

letter_frequency(ARGV[0]).sort_by {|key, val| -val}.each {|pair| p pair}
