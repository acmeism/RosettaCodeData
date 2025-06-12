["gHHH5YY++///\\",
 "aaabbbaaabcdeef"
].each do |s|
  puts s
  puts "   -> " + s.scan(/(.)\1*/).flatten.join(", ")
end
