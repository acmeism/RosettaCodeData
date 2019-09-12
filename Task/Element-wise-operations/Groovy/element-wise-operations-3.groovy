Number.metaClass.mixin NaiveMatrixCategory

println 'Demo 1: functionality as requested'
def a = [[5,3],[4,2]] as NaiveMatrix
println 'a == ' + a
def b = new NaiveMatrix([[1,2],[7,8]])
println 'b == ' + b

def z = [[0,0],[0,0]] as NaiveMatrix
println "a + b  == (${a}) + (${b})  == " + (a + b)
println "a - b  == (${a}) - (${b})  == " + (a - b)
println "a * b  == (${a}) * (${b})  == " + (a * b)
println "a / b  == (${a}) / (${b})  == " + (a / b)
println "a ** b == (${a}) ** (${b}) == " + (a ** b)

println '\nDemo 2: Extended functionality'
println "a % b  == (${a}) % (${b})  == " + (a % b)

println '\nDemo 3: Element-wise scalar operations'

println "2 + b  == 2 + (${b})  == " + (2 + b)
println "2 - b  == 2 - (${b})  == " + (2 - b)
println "2 * b  == 2 * (${b})  == " + (2 * b)
println "2 / b  == 2 / (${b})  == " + (2 / b)
println "2 ** b == 2 ** (${b}) == " + (2 ** b)
println "2 % b  == 2 % (${b})  == " + (2 % b)

println "\na + 2  == (${a}) + 2  == " + (a + 2)
println "a - 2  == (${a}) - 2  == " + (a - 2)
println "a * 2  == (${a}) * 2  == " + (a * 2)
println "a / 2  == (${a}) / 2  == " + (a / 2)
println "a ** 2 == (${a}) ** 2 == " + (a ** 2)
println "a % 2  == (${a}) % 2  == " + (a % 2)
