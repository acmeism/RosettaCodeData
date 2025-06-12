def rlencode (s)
  result = Array({Char, Int32}).new
  s.scan(/(.)\1*/) do |m|
    result << { m[1][0], m[0].size }
  end
  result
end

def rldecode (enc)
  String.build do |s|
    enc.each do |char, length|
      s << char.to_s * length
    end
  end
end

enc = rlencode("WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW")
p enc
puts rldecode(enc)
