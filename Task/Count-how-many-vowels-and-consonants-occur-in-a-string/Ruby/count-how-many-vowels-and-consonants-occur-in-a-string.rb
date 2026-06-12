RE_V = /[aeiou]/
RE_C = /[bcdfghjklmnpqrstvwxyz]/
str  = "Now is the time for all good men to come to the aid of their country."

grouped = str.downcase.chars.group_by do |c|
  case c
    when RE_V then :Vowels
    when RE_C then :Consonants
    else :Other
  end
end

grouped.each{|k,v| puts "#{k}: #{v.size}, #{v.uniq.size} unique."}
