let start = getTime()
var solver = initSolver([Value  0, 12,  9, 13,
                               15, 11, 10, 14,
                                3,  7,  2,  5,
                                4,  8,  6,  1])
solver.run()
echo fmt"Execution time: {(getTime() - start).toString}."
