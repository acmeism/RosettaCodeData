import Foundation


func getPrefix(_ text:[String]) -> String? {
    var common:String = text[0]
    for i in text {
        common = i.commonPrefix(with: common)
    }
    return common
}

var test = ["/home/user1/tmp/coverage/test",
 "/home/user1/tmp/covert/operator",
 "/home/user1/tmp/coven/members"]

var output:String = getPrefix(test)!
print(output)
