import tables

let t1 = {"name": "Rocket Skates", "price": "12.75", "color": "yellow"}.toTable
let t2 = {"price": "15.25", "color": "red", "year": "1974"}.toTable

var t3 = t1   # Makes a copy.
for key, value in t2.pairs:
  t3[key] = value

echo t3
