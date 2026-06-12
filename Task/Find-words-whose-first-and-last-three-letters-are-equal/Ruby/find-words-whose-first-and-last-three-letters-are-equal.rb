puts File.readlines("unixdict.txt", chomp: true).select{|w| w.end_with?(w[0,3]) && w.size > 5}
