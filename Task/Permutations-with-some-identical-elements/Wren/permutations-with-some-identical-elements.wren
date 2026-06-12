import "./perm" for Perm

var createList = Fn.new { |nums, charSet|
    var chars = []
    for (i in 0...nums.count) {
        for (j in 0...nums[i]) chars.add(charSet[i])
    }
    return chars
}

var nums = [2, 1]
var a = createList.call(nums, "12")
System.print(Perm.listDistinct(a).map { |p| p.join() }.toList)
System.print()

nums = [2, 3, 1]
a = createList.call(nums, "123")
System.print(Perm.listDistinct(a).map { |p| p.join() }.toList)
System.print()

a = createList.call(nums, "ABC")
System.print(Perm.listDistinct(a).map { |p| p.join() }.toList)
