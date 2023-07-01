println(a.ensuring(a == 42))
println(a.ensuring(a == 42, "a isn't equal to 42"))
println(a.ensuring(_ == 42))
println(a.ensuring(_ == 42, "a isn't equal to 42"))
