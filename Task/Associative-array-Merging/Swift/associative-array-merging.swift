let base : [String: Any] = ["name": "Rocket Skates", "price": 12.75, "color": "yellow"]
let update : [String: Any] = ["price": 15.25, "color": "red", "year": 1974]

let result = base.merging(update) { (_, new) in new }

print(result)
