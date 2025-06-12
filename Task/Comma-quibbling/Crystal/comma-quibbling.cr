def comma_quibble (arr)
  "{" +
    case arr.size
    when 0
      ""
    when 1
      arr[0]
    else
      arr[..-2].join(", ") + " and #{arr[-1]}"
    end + "}"
end

[[] of String, # (No input words).
 ["ABC"],
 ["ABC", "DEF"],
 ["ABC", "DEF", "G", "H"],
].each do |input|
  puts comma_quibble(input)
end
