def dec2bin(dec, precision=16)    # String => String
  int, df = dec.split(".")
  minus = int.delete!("-")
  bin = (minus ? "-" : "") + int.to_i.to_s(2) + "."
  if df and df.to_i>0
    fp = ("."+df).to_f
    digit = 1
    until fp.zero? or digit>precision
      fp *= 2
      n = fp.to_i
      bin << n.to_s
      fp -= n
      digit += 1
    end
  else
    bin << "0"
  end
  bin
end

def bin2dec(bin)              # String => String
  int, df = bin.split(".")
  minus = int.delete!("-")
  dec = (minus ? "-" : "") + int.to_i(2).to_s
  if df
    dec << (df.to_i(2) / 2.0**(df.size)).to_s[1..-1]
  else
    dec << ".0"
  end
end

data = %w[23.34375 11.90625 -23.34375 -11.90625]
data.each do |dec|
  bin  = dec2bin(dec)
  dec2 = bin2dec(bin)
  puts "%10s => %12s =>%10s" % [dec, bin, dec2]
end
