module BaseConvert
  DIGITS = %w{0 1 2 3 4 5 6 7 8 9 a b c d e f g h i j k l m n o p q r s t u v w x y z}

  def baseconvert(str, basefrom, baseto)
    dec2base(base2dec(str, basefrom), baseto)
  end

  def base2dec(str, base)
    raise ArgumentError, "base is invalid" unless base.between?(2, DIGITS.length)
    res = 0
    str.to_s.downcase.each_char do |c|
      idx = DIGITS[0,base].find_index(c)
      idx.nil? and raise ArgumentError, "invalid base-#{base} digit: #{c}"
      res = res * base + idx
    end
    res
  end

  def dec2base(n, base)
    return "0" if n == 0
    raise ArgumentError, "base is invalid" unless base.between?(2, DIGITS.length)
    res = []
    while n > 0
      n, r = n.divmod(base)
      res.unshift(DIGITS[r])
    end
    res.join("")
  end
end

include BaseConvert
p baseconvert("107h", 23, 7)  # => "50664"
