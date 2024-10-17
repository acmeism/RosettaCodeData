class String
  def lookandsay
    gsub(/(.)\1*/){ |s| s.size.to_s + s[0] }
  end
end

ss = '1'
12.times { puts ss; ss = ss.to_s.lookandsay }
