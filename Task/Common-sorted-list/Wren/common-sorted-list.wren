import "./seq" for Lst
import "./sort" for Sort

var distinctSortedUnion = Fn.new { |ll|
    var res = ll.reduce([]) { |acc, l| acc + l }
    res = Lst.distinct(res)
    Sort.insertion(res)
    return res
}

var ll = [[5, 1, 3, 8, 9, 4, 8, 7], [3, 5, 9, 8, 4], [1, 3, 7, 9]]
System.print("Distinct sorted union of %(ll) is:")
System.print(distinctSortedUnion.call(ll))
