object Dinesman extends App {

  val tenants = List("Baker", "Cooper", "Fletcher", "Miller", "Smith")
  val floors = (1 to tenants.size).toList

  // define the predicates
  import scala.math.abs
  val predicates =
    List((perm: Map[String, Int]) => !(perm("Baker")==floors.size)
        ,(perm: Map[String, Int]) => !(perm("Cooper")==1)
        ,(perm: Map[String, Int]) => !(perm("Fletcher")==1 || perm("Fletcher")==floors.size)
        ,(perm: Map[String, Int]) => !(perm("Miller")<=perm("Cooper"))
        ,(perm: Map[String, Int]) => !(abs(perm("Smith")-perm("Fletcher"))==1)
        ,(perm: Map[String, Int]) => !(abs(perm("Fletcher")-perm("Cooper"))==1)
        )

  val p: Seq[(String, Int)] => Boolean = perm => !predicates.map(_(perm.toMap)).contains(false)

  tenants.permutations.map(_ zip floors).toList
    .map(perm=>Pair(perm,p(perm))).filter(_._2==true).map(p=>p._1.toList)
  match {
    case Nil => println("no solution")
    case xss => { println("solutions: "+xss.size)
                  xss.foreach{l=>
                    println("possible solution:")
                    l.foreach(p=>println("  "+p._1+ " lives on floor number "+p._2))
                  }
                }
  }

}
