def notcell(c)
  c.tr('01','10')
end

def eca_infinite(cells, rule)
  neighbours2next = Hash[8.times.map{|i|["%03b"%i, "01"[rule[i]]]}]
  c = cells
  Enumerator.new do |y|
    loop do
      y << c
      c = notcell(c[0])*2 + c + notcell(c[-1])*2        # Extend and pad the ends
      c = (1..c.size-2).map{|i| neighbours2next[c[i-1..i+1]]}.join
    end
  end
end

if __FILE__ == $0
  lines = 25
  for rule in [90, 30]
    puts "\nRule: %i" % rule
    for i, c in (0...lines).zip(eca_infinite('1', rule))
      puts '%2i: %s%s' % [i, ' '*(lines - i), c.tr('01', '.#')]
    end
  end
end
