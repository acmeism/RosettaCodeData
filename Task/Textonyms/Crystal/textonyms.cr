filename = "unixdict.txt"
from = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
to   = "2223334445556667777888999922233344455566677778889999"

mapping = File.read(filename).each_line.reject(/[^A-Za-z]/).group_by {|w| w.tr(from, to) }
textonyms = mapping.select { |k, v| v.size > 1 }

nwords = mapping.values.map(&.size).sum

puts "There are #{nwords} words in #{filename} which can be represented by the digit key mapping."
puts "They require #{mapping.size} digit combinations to represent them."
puts "#{textonyms.size} digit combinations represent Textonyms."

# let's find something original

repeated = mapping.keys.select(/^(.)\1\1+$/).sort_by(&.size).reverse
puts
puts "Least-effort words"
repeated.each do |w|
  puts "  #{w}\t #{mapping[w].join(", ")}"
end
