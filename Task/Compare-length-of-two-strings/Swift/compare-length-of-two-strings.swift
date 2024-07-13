 let list = ["abcd", "abcd🤦‍♂️", "123456789", "abcdef", "1234567"]
 list.sorted { $0.count > $1.count }.forEach { string in
     print("\(string) has \(string.count) characters")
 }
