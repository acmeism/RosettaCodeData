def fibonacciProgram = '''
x < 1 ? 0 : x == 1 ? 1 : (2..x).inject([0,1]){i, j -> [i[1], i[0]+i[1]]}[1]
'''

println "F(${10}) - F(${5}) = ${Eval.x(10, fibonacciProgram)} - ${Eval.x(5, fibonacciProgram)} = " + cruncher(10, 5, fibonacciProgram)
