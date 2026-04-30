letters = ((0.chr)..Char::MAX).group_by { |ch|
  case ch
  when .lowercase? then :lower
  when .uppercase? then :upper
  else :neither
  end
}

puts "Lowercase: #{letters[:lower].join(" ")}"
puts "Uppercase: #{letters[:upper].join(" ")}"
