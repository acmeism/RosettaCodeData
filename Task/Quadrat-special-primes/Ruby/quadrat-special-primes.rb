require 'prime'

res = [2]

until res.last > 16000 do
  res << (1..).detect{|n| (res.last + n**2).prime? } ** 2 + res.last
end

puts res[..-2].join(" ")
