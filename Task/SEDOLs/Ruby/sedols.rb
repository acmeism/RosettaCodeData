Sedol_char = "0123456789BCDFGHJKLMNPQRSTVWXYZ"
Sedolweight = [1,3,1,7,3,9]

def char2value(c)
  raise ArgumentError, "Invalid char #{c}" unless Sedol_char.include?(c)
  c.to_i(36)
end

def checksum(sedol)
  raise ArgumentError, "Invalid length" unless sedol.size == Sedolweight.size
  sum = sedol.chars.zip(Sedolweight).sum{|ch, weight| char2value(ch) * weight }
  ((10 - (sum % 10)) % 10).to_s
end

data = %w(710889
          B0YBKJ
          406566
          B0YBLH
          228276
          B0YBKL
          557910
          B0YBKR
          585284
          B0YBKT
          B00030
          C0000
          1234567
          00000A)

data.each do |sedol|
  print "%-8s " % sedol
  begin
    puts sedol + checksum(sedol)
  rescue => e
    p e
  end
end
