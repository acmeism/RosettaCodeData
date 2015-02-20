require "bigdecimal"

LN2 = BigMath::log(2,16)  #Use LN2 = Math::log(2) to see the difference with floats
FACTORIALS = Hash.new{|h,k,v| h[k]=k * h[k-1]}
FACTORIALS[0] = 1

def hickerson(n)
  FACTORIALS[n] / (2 * LN2 ** (n+1))
end

def nearly_int?(n)
  int = n.round
  n.between?(int - 0.1, int + 0.1)
end

1.upto(17) do |n|
  h = hickerson(n)
  str = nearly_int?(h) ? "nearly integer" : "NOT nearly integer"
  puts "n:%3i h: %s\t%s" % [n, h.to_s('F')[0,25], str] #increase the 25 to print more digits, there are 856 of them
end
