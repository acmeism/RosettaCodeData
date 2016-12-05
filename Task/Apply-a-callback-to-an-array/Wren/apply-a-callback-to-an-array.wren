var arr = [1, 2, 3, 4, 5]
arr = arr.map { |x| x * 2 }.toList
arr = arr.map(Fn.new {|x| x / 2}).toList
arr.each {|x| System.print(x) }
