rlcs(_ s1: String, _ s2: String) -> String {
   if s1.count == 0 || s2.count == 0 {
       return ""
   } else if s1[s1.index(s1.endIndex, offsetBy: -1)] == s2[s2.index(s2.endIndex, offsetBy: -1)] {
       return rlcs(String(s1[s1.startIndex..<s1.index(s1.endIndex, offsetBy: -1)]),
                   String(s2[s2.startIndex..<s2.index(s2.endIndex, offsetBy: -1)])) + String(s1[s1.index(s1.endIndex, offsetBy: -1)])
   } else {
       let str1 = rlcs(s1, String(s2[s2.startIndex..<s2.index(s2.endIndex, offsetBy: -1)]))
       let str2 = rlcs(String(s1[s1.startIndex..<s1.index(s1.endIndex, offsetBy: -1)]), s2)

       return str1.count > str2.count ? str1 : str2
   }
}
