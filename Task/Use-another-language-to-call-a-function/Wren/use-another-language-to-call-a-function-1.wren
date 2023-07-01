/* query.wren */

class RCQuery {
    // Both arguments are lists as we need pass by reference here
    static query(Data, Length) {
        var s = "Here am I"
        var sc = s.count
        if (sc > Length[0]) return 0 // buffer too small
        for (i in 0...sc) Data[i] = s[i].bytes[0]
        Length[0] = sc
        return 1
    }
}
