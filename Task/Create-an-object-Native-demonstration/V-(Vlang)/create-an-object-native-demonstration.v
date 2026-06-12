mut hma := map[string]int{} // mutable via using "mut"
hma["A"] = 40
hma["B"] = 41
hma["C"] = 42
println(hma)
println(hma["F"]) // non-existent keys return 0 by default

hma.delete("C") // deletion of key possible, as was declared mutable ("mut")
println(hma)

hmb := {"D": 50, "E": 51, "F": 52} // immutable hash map
println(hmb)
hmb.delete("F") // attempting to delete an immutable key will cause an error
hmb["D"] = 60 // attempting to change an immutable value will also cause an error
