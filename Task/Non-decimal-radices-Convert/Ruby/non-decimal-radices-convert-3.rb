module BaseConvert
  DIGITS = [*"0".."9", *"a".."z"]

  def baseconvert(str, basefrom, baseto)
    dec2base(base2dec(str, basefrom), baseto)
  end

  def base2dec(str, base)
    raise ArgumentError, "base is invalid" unless base.between?(2, DIGITS.length)
    str.to_s.downcase.each_char.inject(0) do |res, c|
      idx = DIGITS[0,base].index(c)
      idx.nil? and raise ArgumentError, "invalid base-#{base} digit: #{c}"
      res = res * base + idx
    end
  end

  def dec2base(n, base)
    return "0" if n == 0
    raise ArgumentError, "base is invalid" unless base.between?(2, DIGITS.length)
    res = []
    while n > 0
      n, r = n.divmod(base)
      res.unshift(DIGITS[r])
    end
    res.join
  end
end

include BaseConvert
p dec2base(26, 16)            # => "1a"
p base2dec("1a", 16)          # => 26
p baseconvert("107h", 23, 7)  # => "50664"
