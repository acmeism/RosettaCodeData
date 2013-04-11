def m4by2 = [ [  1,  2 ],
              [  3,  4 ],
              [  5,  6 ],
              [  7,  8 ] ]

def m2by3 = [ [  1,  2,  3 ],
              [  4,  5,  6 ] ]

matmulWOIL(m4by2, m2by3).each { println it }
println()
matmulWOT(m4by2, m2by3).each { println it }
