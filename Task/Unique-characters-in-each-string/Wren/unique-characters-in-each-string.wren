import "./seq" for Lst
import "./sort" for Sort

var strings = ["1a3c52debeffd", "2b6178c97a938stf", "3ycxdb1fgxa2yz"]
var uniqueChars = []
for (s in strings) {
    var u = Lst.individuals(s.toList).where { |l| l[1] == 1 }.map { |l| l[0] }
    uniqueChars.addAll(u)
}
var n = strings.count
uniqueChars = Lst.individuals(uniqueChars).where { |l| l[1] == n }.map { |l| l[0] }.toList
Sort.insertion(uniqueChars)
System.print("Found %(uniqueChars.count) unique character(s) common to each string, namely:")
System.print(uniqueChars.join(" "))
