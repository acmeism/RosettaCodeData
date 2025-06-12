["", "   ", "2", "333", ".55", "tttTTT", "4444 4444k", "pépé", "🐶🐶🐺🐶", "🎄🎄🎄🎄"].each do |s|
  print "‘#{s}’, length #{s.size}: "
  chars = s.chars
  if chars.present? && (pos = chars.index {|ch| ch != chars[0] })
    puts "all characters are NOT the same. " +
         "First different: ‘#{chars[pos]}’ (0x#{chars[pos].ord.to_s(16)}) at #{pos}."
  else
    puts "all characters are the same."
  end
end
