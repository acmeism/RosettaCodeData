// iterate over key/value
hash.foreach {e => println("key "+e._1+" value "+e._2)} // e is a 2 element Tuple
// same with for syntax
for((k,v) <- hash) println("key " + k + " value " + v)
