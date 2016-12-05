import Foundation

func octalSuccessor(value: String) -> String {
   if value.isEmpty {
        return "1"
   } else {
     let i = value.startIndex, j = value.endIndex.predecessor()
     switch (value[j]) {
       case "0": return value[i..<j] + "1"
       case "1": return value[i..<j] + "2"
       case "2": return value[i..<j] + "3"
       case "3": return value[i..<j] + "4"
       case "4": return value[i..<j] + "5"
       case "5": return value[i..<j] + "6"
       case "6": return value[i..<j] + "7"
       case "7": return octalSuccessor(value[i..<j]) + "0"
       default:
         NSException(name:"InvalidDigit", reason: "InvalidOctalDigit", userInfo: nil).raise();
         return ""
     }
  }
}

var n = "0"
while strtoul(n, nil, 8) < UInt.max {
  println(n)
  n = octalSuccessor(n)
}
