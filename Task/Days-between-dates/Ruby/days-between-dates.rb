require "date"

d1, d2 = Date.parse("2019-1-1"), Date.parse("2019-10-19")

p (d1 - d2).to_i  # => -291
p (d2 - d1).to_i  # => 291
