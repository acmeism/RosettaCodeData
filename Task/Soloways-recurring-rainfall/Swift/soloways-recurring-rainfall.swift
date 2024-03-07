import Foundation

var mean: Double = 0
var count: Int = 0
var prompt = "Enter integer rainfall or 99999 to exit:"
var term = " "
print(prompt, terminator: term)
while let input = readLine() {
	defer {
		print("count: \(count), mean: \(mean.formatted())\n\(prompt)", terminator: term)
	}
	guard let val = Int(input) else {
		print("Integer values only")
		continue
	}
	if val == 99999 {
		(prompt, term) = ("Done","\n")
		break
	}
	count += 1
	mean += Double(val)/Double(count) - mean/Double(count)
}
