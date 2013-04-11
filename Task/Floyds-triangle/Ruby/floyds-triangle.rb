raise ArgumentError, "Usage: #{$0} ROWS" unless
  ARGV.length == 1 && (rows = ARGV[0].to_i) > 0

max = (rows * (rows + 1)) / 2
widths = ((max - rows + 1)..max).map {|n| n.to_s.length + 1}

n = 0
rows.times do |r|
  (r+1).times do |i|
    n += 1
    print "%#{widths[i]}d" % n
  end
  print "\n"
end
