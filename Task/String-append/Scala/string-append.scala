  var d = "Hello" // Mutables are discouraged     //> d  : String = Hello
  d += ", World!" // var contains a totally new re-instantiationed String

  val s = "Hello" // Immutables are recommended   //> s  : String = Hello
  val s1 = s + s                                  //> s1  : String = HelloHello
  val f2 = () => " !" //Function assigned to variable
                                                  //> f2  : () => String = <function0>
  println(s1 + f2());                             //> HelloHello !
