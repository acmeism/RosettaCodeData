def join_nouns (list)
  case list.size
  when 0; ""
  when 1; list[0]
  else "#{list[..-2].join(", ")} and #{list[-1]}"
  end
end

def nice? (name)
  (name.downcase.chars.to_set & "nice".chars.to_set).size >= 2
end

def lovable_by? (sailor, lady)
  (sailor.size - lady.size).abs <= 1
end

sailor = "Sinbad"
ladies = %w{Ada Cee Crystal Dee Euphoria Io Janet Julia Miranda Pearl Ruby}

nice_ladies = ladies.select { |l| nice? l }
lovable = nice_ladies.select { |l| lovable_by? sailor, l }

puts "The ladies are #{join_nouns(ladies)}."
puts "Of those, #{join_nouns(nice_ladies)} are nice"
puts " and #{sailor} finds #{join_nouns(lovable)} lovable."
