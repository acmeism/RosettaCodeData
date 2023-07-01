var keys = [1, 2, 3, 4, 5]
var values = ["first", "second", "third", "fourth","fifth"]
var hash = {}
(0..4).each { |i| hash[keys[i]] = values[i] }
System.print(hash)
