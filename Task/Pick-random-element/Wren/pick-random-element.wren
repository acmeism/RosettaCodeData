import "random" for Random

var rand = Random.new()
var colors = ["red", "green", "blue", "yellow", "pink"]
for (i in 0..4) System.print(colors[rand.int(colors.count)])
