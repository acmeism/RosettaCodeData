import "./seq" for Lst
import "./sort" for Sort

var strings = ["133252abcdeeffd", "a6789798st","yxcdfgxcyz"]
var totalChars = strings.reduce { |acc, str| acc + str }.toList
var uniqueChars = Lst.individuals(totalChars).where { |l| l[1] == 1 }.map { |l| l[0] }.toList
Sort.insertion(uniqueChars)
System.print("Found %(uniqueChars.count) unique character(s), namely:")
System.print(uniqueChars.join(" "))
