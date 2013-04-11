i = 1
loop do
   j = 1
   loop do
      print "*"
      break if (j += 1) > i
   end
   puts
   break if (i += 1) > 5
end
