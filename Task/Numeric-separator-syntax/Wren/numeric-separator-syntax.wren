import "./fmt" for Fmt

var nums = [1e6, 1e9, 123456789, -123456789012]
var seps = [",", ".", " ", "*"]
for (i in 0...nums.count) System.print(Fmt.commatize(nums[i], seps[i]))
