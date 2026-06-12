def hexdump (bytes : Bytes, base=16, start=0, length=-1)
  start = 0 if start < 0
  start = bytes.size if start > bytes.size
  length = (bytes.size - start) if length < 0 || start + length > bytes.size
  raise "only base 2, 8 or 16 supported" unless [2, 8, 16].includes? base

  fmt, space, sep, chunksize = case base
                               when 2;  { " %08b", " "*9, -1,  6 }
                               when 8;  { " %03o", " "*4,  6, 12 }
                               when 16; { " %02X", " "*3,  8, 16 }
                               end.not_nil!
  offset = start
  bytes[start, length].each_slice(chunksize) do |chunk|
    printf "%08X ", offset
    chunksize.times do |idx|
      print " " if idx == sep
      if idx < chunk.size
        printf(fmt, chunk[idx])
      else
        print space
      end
    end
    print "  |"
    chunk.each do |byte|
      if 32 <= byte <= 126
        print byte.chr
      else
        print "."
      end
    end
    puts "|"
    offset += chunksize
  end
end

string = "Rosetta Code is a programming chrestomathy site 😀."

puts string
puts
puts "Hex dump UTF-16BE, offset 0"
hexdump string.encode("UTF-16BE")
puts
puts "Oct dump UTF-16LE, offset 10"
hexdump string.encode("UTF-16LE"), 8, 10
puts
puts "Bin dump UTF-8, offset 18, length 11"
hexdump string.to_slice, 2, 18, 11

puts
puts "Built-in hexdump:"
puts "Hex dump UTF-16BE"
string.encode("UTF-16BE").hexdump(STDOUT)
