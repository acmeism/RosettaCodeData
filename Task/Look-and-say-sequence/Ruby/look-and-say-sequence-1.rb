class String
  def look_and_say
    gsub(/(.)\1*/){|s| s.size.to_s + s[0]}
  end
end

ss = '1'
12.times {puts ss; ss = ss.look_and_say}
