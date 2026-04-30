def strip_comments (s)
  s.sub(/[#;].*$/, "").strip
end

"apples, pears # and bananas
apples, pears ; and bananas
   apples, pears  # xxx
 apples, pears   ".each_line do |line|
  puts strip_comments(line).inspect
end
