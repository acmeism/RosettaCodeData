CHARS = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
NUMS  = "22233344455566677778889999" * 2
dict  = "unixdict.txt"

textonyms = File.open(dict){|f| f.map(&:chomp).group_by {|word| word.tr(CHARS, NUMS) } }

puts "There are #{File.readlines(dict).size} words in #{dict} which can be represented by the digit key mapping.
They require #{textonyms.size} digit combinations to represent them.
#{textonyms.count{|_,v| v.size > 1}} digit combinations represent Textonyms."

puts "\n25287876746242: #{textonyms["25287876746242"].join(", ")}"
