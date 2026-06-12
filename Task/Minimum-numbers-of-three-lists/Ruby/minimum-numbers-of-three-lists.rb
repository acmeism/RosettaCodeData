numbers1 = [ 5, 45, 23, 21, 67]
numbers2 = [43, 22, 78, 46, 38]
numbers3 = [ 9, 98, 12, 98, 53]

p [numbers1, numbers2, numbers3].transpose.map(&:min)
