import "io" for File

var dict = File.read("unixdict.txt").split("\n")
var wmap = {}
dict.each { |w| wmap[w] = true }
var pairs = []
var used = {}
for (word in dict) {
    if (word != "") {
        var pal = word[-1..0]
        if (word != pal && wmap[pal] && !used[pal]) {
            pairs.add([word, pal])
            used[word] = true
        }
    }
}
System.print("There are %(pairs.count) unique semordnilap pairs in the dictionary.")
System.print("\nIn sorted order, the first five are:")
for (i in 0..4) System.print("  %(pairs[i][0]), %(pairs[i][1])")
System.print("\nand the last five are:")
for (i in -5..-1) System.print("  %(pairs[i][0]), %(pairs[i][1])")
