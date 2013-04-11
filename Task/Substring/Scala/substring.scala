val str = "The good life is one inspired by love and guided by knowledge."
val n = 21
val m = 16

println(str.slice(n, n+m))
println(str.slice(n, str.length))
println(str.slice(0, str.length-1))
println(str.slice(str.indexOf('l'), str.indexOf('l')+m))
println(str.slice(str.indexOf("good"), str.indexOf("good")+m))
