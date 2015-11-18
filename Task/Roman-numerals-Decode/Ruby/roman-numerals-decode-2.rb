SYMBOLS = [ ['M', 1000], ['CM', 900], ['D', 500], ['CD', 400], ['C', 100], ['XC', 90],
            ['L', 50], ['XL', 40], ['X', 10], ['IX', 9], ['V', 5], ['IV', 4], ['I', 1] ]

def parseRoman(roman)
  r = roman.upcase
  n = 0
  SYMBOLS.each { |sym, val| n += val while r.sub!(/^#{sym}/, "") }
  n
end

[ "MCMXC", "MMVIII", "MDCLXVI" ].each {|r| puts "%8s :%5d" % [r, parseRoman(r)]}
