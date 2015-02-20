Textonyms = Hash.new {|n, g| n[g] = []}
File.open("Textonyms.txt") do |file|
  file.each_line {|line|
    Textonyms[(n=line.chomp).gsub(/a|b|c|A|B|C/, '2').gsub(/d|e|f|D|E|F/, '3').gsub(/g|h|i|G|H|I/, '4').gsub(/p|q|r|s|P|Q|R|S/, '7')
                     .gsub(/j|k|l|J|K|L/, '5').gsub(/m|n|o|M|N|O/, '6').gsub(/t|u|v|T|U|V/, '8').gsub(/w|x|y|z|W|X|Y|Z/, '9')] += [n]
  }
end
