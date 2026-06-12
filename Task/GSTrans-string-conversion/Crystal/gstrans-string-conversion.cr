def gsencode (bytes)
  String.build do |s|
    bytes.each do |b|
      if b >= 128
        s << '|' << '!'
        b -= 128
      end
      case b
      when 0..31   then s << '|' << (b+64).chr
      when 34, 124 then s << '|' << b.chr
      when 32..126 then s << b.chr
      when 127     then s << '|' << '?'
      end
    end
  end
end

def gsdecode (string)
  buf = [] of UInt8
  bar = false
  add : UInt8 = 0
  string.each_char do |ch|
    code = ch.ord.to_u8
    if !bar
      if ch == '|'
        bar = true
      else
        buf << code + add
        add = 0
      end
    else  # previous was bar
      bar = false
      if ch == '!'
        add = 128
      else
        case ch
        when '"', '|' then buf << code + add
        when '?'      then buf << 127u8 + add
        when '@'..'_' then buf << code - 64 + add
        else raise "invalid bar-escape #{ch.inspect}"
        end
        add = 0
      end
    end
  end
  raise "invalid bar at end of string" if bar
  buf
end

def roundtrip (s)
  enc = gsencode(s.bytes)
  dec = gsdecode(enc)
  decstr = String.new(dec.to_unsafe, dec.size)
  puts "original: #{s.inspect}"
  puts " encoded: #{enc.inspect}"
  puts " decoded: #{decstr.inspect} (#{dec.inspect})"
  puts
end

roundtrip "\fHello\a\n\r"
roundtrip "\x01\x02\x9a"
roundtrip "l'émoji: 😀"
