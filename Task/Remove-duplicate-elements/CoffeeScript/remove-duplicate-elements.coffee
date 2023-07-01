data = [ 1, 2, 3, "a", "b", "c", 2, 3, 4, "b", "c", "d" ]
set = []
set.push i for i in data when not (i in set)

console.log data
console.log set
