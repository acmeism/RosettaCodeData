var random = Fn.new { |seed| ((seed * seed)/1e3).floor % 1e6 }

var seed = 675248
for (i in 1..5) System.print(seed = random.call(seed))
