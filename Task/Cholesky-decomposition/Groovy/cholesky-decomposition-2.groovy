def test1 = [[25, 15, -5],
             [15, 18,  0],
             [-5,  0, 11]]

def test2 = [[18, 22, 54, 42],
             [22, 70, 86, 62],
             [54, 86, 174, 134],
             [42, 62, 134, 106]];

[test1,test2]. each { test ->
    println()
    decompose(test).each { println it[0..<(test.size)] }
}
