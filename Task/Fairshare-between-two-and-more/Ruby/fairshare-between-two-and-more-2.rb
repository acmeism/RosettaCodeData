def fairshare(base, upto) = (0...upto).map{|n| n.digits(base).sum % base}

upto = 25
[2, 3, 5, 11].each{|b| puts"#{'%2d' % b}: " + " %2d"*upto % fairshare(b, upto)}
