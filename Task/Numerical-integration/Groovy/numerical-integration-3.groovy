println "f(x) = x**3, where x is [0,1], with 100 approximations. The exact result is 1/4, or 0.25."
println ([" LeftRect":  leftRectIntegral([0d, 1d], 100) { it**3 }])
println (["RightRect": rightRectIntegral([0d, 1d], 100) { it**3 }])
println (["  MidRect":   midRectIntegral([0d, 1d], 100) { it**3 }])
println (["Trapezoid": trapezoidIntegral([0d, 1d], 100) { it**3 }])
println ([" Simpsons":  simpsonsIntegral([0d, 1d], 100) { it**3 }])
println ()

println "f(x) = 1/x, where x is [1, 100], with 1,000 approximations. The exact result is the natural log of 100, or about 4.605170."
println ([" LeftRect":  leftRectIntegral([1d, 100d], 1000) { 1/it }])
println (["RightRect": rightRectIntegral([1d, 100d], 1000) { 1/it }])
println (["  MidRect":   midRectIntegral([1d, 100d], 1000) { 1/it }])
println (["Trapezoid": trapezoidIntegral([1d, 100d], 1000) { 1/it }])
println ([" Simpsons":  simpsonsIntegral([1d, 100d], 1000) { 1/it }])
println ()

println "f(x) = x, where x is [0,5000], with 5,000,000 approximations. The exact result is 12,500,000."
println ([" LeftRect":  leftRectIntegral([0d, 5000d], 5000000) { it }])
println (["RightRect": rightRectIntegral([0d, 5000d], 5000000) { it }])
println (["  MidRect":   midRectIntegral([0d, 5000d], 5000000) { it }])
println (["Trapezoid": trapezoidIntegral([0d, 5000d], 5000000) { it }])
println ([" Simpsons":  simpsonsIntegral([0d, 5000d], 5000000) { it }])
println ()

println "f(x) = x, where x is [0,6000], with 6,000,000 approximations. The exact result is 18,000,000."
println ([" LeftRect":  leftRectIntegral([0d, 6000d], 6000000) { it }])
println (["RightRect": rightRectIntegral([0d, 6000d], 6000000) { it }])
println (["  MidRect":   midRectIntegral([0d, 6000d], 6000000) { it }])
println (["Trapezoid": trapezoidIntegral([0d, 6000d], 6000000) { it }])
println ([" Simpsons":  simpsonsIntegral([0d, 6000d], 6000000) { it }])
println ()
