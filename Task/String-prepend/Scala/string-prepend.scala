  val s = "World" // Immutables are recommended   //> s  : String = World
  val f2 = () => ", " //Function assigned to variable
                                                  //> f2  : () => String = <function0>
  val s1 = "Hello" + f2() + s                     //> s1  : String = Hello, World
  println(s1);                                    //> Hello, World
