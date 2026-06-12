import "./str" for Str

var vowels = "aeiou"
var consonants = "bcdfghjklmnpqrstvwxyz"

var strs = [
    "Forever Wren programming language",
    "Now is the time for all good men to come to the aid of their country."
]

for (str in strs) {
    System.print(str)
    str = Str.lower(str)
    var vc = 0
    var cc = 0
    var vmap = {}
    var cmap = {}
    for (c in str) {
        if (vowels.contains(c)) {
            vc = vc  + 1
            vmap[c] = true
        } else if (consonants.contains(c)) {
            cc = cc + 1
            cmap[c] = true
        }
    }
    System.print("contains (total) %(vc) vowels and %(cc) consonants.")
    System.print("contains (distinct) %(vmap.count) vowels and %(cmap.count) consonants.\n")
}
