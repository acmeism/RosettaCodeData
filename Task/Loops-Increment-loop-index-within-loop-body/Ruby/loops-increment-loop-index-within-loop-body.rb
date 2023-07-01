require 'prime'

limit = 42
i = 42
n = 0

while n < limit do
  if i.prime? then
    n += 1
    puts "n = #{n}".ljust(7) + ":" + "#{i.to_s.reverse.scan(/\d{3}|.+/).join(",").reverse}".rjust(19)
    i += i
  else
    i += 1
  end
end
