iex(61)> deg = 45
45
iex(62)> rad = :math.pi / 4
0.7853981633974483
iex(63)> :math.sin(deg * :math.pi / 180) == :math.sin(rad)
true
iex(64)> :math.cos(deg * :math.pi / 180) == :math.cos(rad)
true
iex(65)> :math.tan(deg * :math.pi / 180) == :math.tan(rad)
true
iex(66)> temp = :math.acos(:math.cos(rad))
0.7853981633974483
iex(67)> temp * 180 / :math.pi == deg
true
iex(68)> temp = :math.atan(:math.tan(rad))
0.7853981633974483
iex(69)> temp * 180 / :math.pi == deg
true
