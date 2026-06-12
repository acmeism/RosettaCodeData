all_vowels = /^[aeiouy]+$/
all_consonants = /^[^aeiou]*[^aeiouy]$/

File.open("unixdict.txt") do |f|
  f.each_line do |line|
    next unless line.size > 9
    chars = line.chars
    odds  = chars.each_step(2).join
    evens = chars.each_step(2, offset: 1).join
    puts line  if odds =~ all_vowels && evens =~ all_consonants ||
                  odds =~ all_consonants && evens =~ all_vowels
  end
end
