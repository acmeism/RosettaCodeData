class Arithmetic {
    static mode(arr) {
        var map = {}
        for (e in arr) {
            if (map[e] == null) map[e] = 0
            map[e] = map[e] + 1
        }
        var max = map.values.reduce {|x, y| x > y ? x : y}
        return map.keys.where {|x| map[x] == max}.toList
    }
}

System.print(Arithmetic.mode([1,2,3,4,5,5,51,2,3]))
