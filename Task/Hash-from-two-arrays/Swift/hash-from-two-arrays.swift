let keys = ["a","b","c"]
let vals = [1,2,3]
var hash = [String: Int]()
for (key, val) in zip(keys, vals) {
  hash[key] = val
}
