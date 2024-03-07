import "random" for Random
import "./sort" for Sort

var bogoSort = Fn.new { |a|
    var rand = Random.new()
    while (!Sort.isSorted(a)) rand.shuffle(a)
}

var a = [31, 41, 59, 26, 53, 58, 97, 93, 23, 84]
System.print("Before: %(a)")
bogoSort.call(a)
System.print("After : %(a)")
