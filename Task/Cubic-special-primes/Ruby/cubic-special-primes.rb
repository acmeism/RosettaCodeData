require 'prime'

res = [2]

until res.last > 15000 do
  res << (1..).detect{|n| (res.last + n**3).prime? } ** 3 + res.last
end

puts res[..-2].join(" ")
