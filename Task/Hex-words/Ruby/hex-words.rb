def report(a)
  puts
  a.each {|hexword| puts "%6s  %8d  %d" % hexword}
  puts "Total count of these words: #{a.size}"
end

hexwords = File.readlines("unixdict.txt", chomp: true).reject{|w| w.size < 4 || w.match?(/[^abcdef]/) }
res = hexwords.map{|hw| [hw, hw.to_i(16), 1 + (hw.to_i(16) - 1) % 9]}.sort_by(&:last)
report( res )
report( res.reject{|hw| hw[0].chars.uniq.size < 4}.sort_by{|w| -w[1]} )
