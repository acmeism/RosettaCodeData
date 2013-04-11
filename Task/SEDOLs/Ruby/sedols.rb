def char2value(c)
  raise "No vowels" if 'AEIOU'.include?(c)
  c.to_i(36)
end

Sedolweight = [1,3,1,7,3,9]

def checksum(sedol)
    tmp = sedol.split('').zip(Sedolweight).map { |ch, weight|
              char2value(ch) * weight }.inject(0) { |sum, x|
              sum + x }
    ((10 - (tmp % 10)) % 10).to_s
end

for sedol in %w{
    710889
    B0YBKJ
    406566
    B0YBLH
    228276
    B0YBKL
    557910
    B0YBKR
    585284
    B0YBKT
    }
    puts sedol + checksum(sedol)
end
