strings = ["", "   ", "2", "333", ".55", "tttTTT", "4444   444k", "pépé", "🐶🐶🐺🐶", "🎄🎄🎄🎄"]

strings.each do |str|
  pos = str.empty? ? nil : str =~ /[^#{str[0]}]/
  print "#{str.inspect}  (size #{str.size}): "
  puts pos ? "first different char #{str[pos].inspect} (#{'%#x' % str[pos].ord}) at position #{pos}." : "all the same."
end
