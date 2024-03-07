import "./sort" for Cmp, Sort

var cmp = Fn.new { |s, t|
    if (s.count < t.count) return 1
    if (s.count > t.count) return -1
    return Cmp.insensitive.call(s, t)
}

var strings = ["Here", "are", "some", "sample", "strings", "to", "be", "sorted"]
System.print("Unsorted: %(strings)")
Sort.insertion(strings, cmp)
System.print("Sorted  : %(strings)")
