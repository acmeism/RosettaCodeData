function digits(n) return math.floor(math.log(n) / math.log(10))+1 end
function fixedprint(num, digs) --digs = number of digits before decimal point
  for i = 1, digs - digits(num) do
    io.write"0"
  end
  print(num)
end

fixedprint(7.125, 5) --> 00007.125
