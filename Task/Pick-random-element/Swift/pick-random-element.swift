import Darwin

let myList = [1, 2, 4, 5, 62, 234, 1, -1]
print(myList[Int(arc4random_uniform(UInt32(myList.count)))])
