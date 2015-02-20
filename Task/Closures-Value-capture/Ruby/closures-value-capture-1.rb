list = {}
(1..10).each {|i| list[i] = proc {i * i}}
p list[3].call      #=> 9
p list[7][]         #=> 49
i = 5
p list[3].call      #=> 9
