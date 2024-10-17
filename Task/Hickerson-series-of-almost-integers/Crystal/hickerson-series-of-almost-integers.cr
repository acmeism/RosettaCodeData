require "big"

LN2 = Math.log(2).to_big_f

FACTORIALS = Hash(Int32, Float64).new{|h,k| h[k] = k * h[k-1]}
FACTORIALS[0] = 1

def hickerson(n)
  FACTORIALS[n] / (2 * LN2 ** (n+1))
end

def nearly_int?(n)
  int = n.round
  (int - 0.1..int + 0.1).includes? n
end

1.upto(17) do |n|
  h = hickerson(n)
  str = nearly_int?(h) ? "nearly integer" : "NOT nearly integer"
  puts "n:%3i h: %s\t%s" % [n, h, str]
end
