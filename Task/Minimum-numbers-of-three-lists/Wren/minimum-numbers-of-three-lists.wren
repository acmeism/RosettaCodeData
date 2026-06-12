var numbers1 = [ 5, 45, 23, 21, 67]
var numbers2 = [43, 22, 78, 46, 38]
var numbers3 = [ 9, 98, 12, 98, 53]
var numbers  = List.filled(5, 0)
for (n in 0..4) numbers[n] = numbers1[n].min(numbers2[n]).min(numbers3[n])
System.print(numbers)
