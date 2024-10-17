testm = [["the", "cat", "sat", "on", "the", "mat"],
         ["the", "cat", "sat", "on", "the", "mat"],
         ["A", "B", "C", "A", "B", "C", "A", "B", "C"],
         ["A", "B", "C", "A", "B", "D", "A", "B", "E"],
         ["A", "B"],
         ["A", "B"],
         ["A", "B", "B", "A"],
]

testn = [["mat", "cat"],
         ["cat", "mat"],
         ["C", "A", "C", "A"],
         ["E", "A", "D", "A"],
         ["B"],
         ["B", "A"],
         ["B", "A"],
]

for i in 1:length(testm)
    m = join(testm[i], " ")
    n = join(testn[i], " ")
    p = join(order_disjoint(testm[i], testn[i]), " ")
    println("    (", m, ", ", n, ") => ", p)
end
