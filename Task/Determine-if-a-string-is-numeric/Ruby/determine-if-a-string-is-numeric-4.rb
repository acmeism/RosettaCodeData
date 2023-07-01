strings = %w(0 0.0 -123 abc 0x10 0xABC 123a -123e3 0.1E-5 50e)
strings.each do |str|
  puts "%9p => %s" % [str, is_numeric?(str)]
end
