? def x := ["a" => 1, "b" => [x].diverge()]
# value: ["a" => 1, "b" => [<***CYCLE***>].diverge()]

? def y := deepcopy(x)
# value: ["a" => 1, "b" => [<***CYCLE***>].diverge()]

? y["b"].push(2)

? y
# value: ["a" => 1, "b" => [<***CYCLE***>, 2].diverge()]

? x
# value: ["a" => 1, "b" => [<***CYCLE***>].diverge()]

? y["b"][0] == y
# value: true

? y["b"][0] == x
# value: false

? x["b"][0] == x
# value: true
