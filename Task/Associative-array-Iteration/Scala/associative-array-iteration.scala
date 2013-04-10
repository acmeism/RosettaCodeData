val m=Map("Hello"->13, "world"->31, "!"->71)

println("Keys:")
m.keys foreach println

println("\nValues:")
m.values foreach println

println("\nPairs:")
m foreach println

println("\nKey->Value:")
for((k,v)<-m) println(k+"->"+v)
