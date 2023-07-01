let start = getTime()
var solver = initSolver([Value 15, 14,  1,  6,
                                9, 11,  4, 12,
                                0, 10,  7,  3,
                               13,  8,  5,  2])
solver.run()
echo fmt"Execution time: {(getTime() - start).toString}."
