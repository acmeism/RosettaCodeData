import scala.math.abs

object Dinesman3 extends App {
  val tenants = List("Baker", "Cooper2", "Fletcher4", "Miller", "Smith")
  val (groundFloor, topFloor) = (1, tenants.size)

  /** Rules with related tenants and restrictions*/
  val exclusions =
    List((suggestedFloor0: Map[String, Int]) => suggestedFloor0("Baker") != topFloor,
      (suggestedFloor1: Map[String, Int]) => suggestedFloor1("Cooper2") != groundFloor,
      (suggestedFloor2: Map[String, Int]) => !List(groundFloor, topFloor).contains(suggestedFloor2("Fletcher4")),
      (suggestedFloor3: Map[String, Int]) => suggestedFloor3("Miller") > suggestedFloor3("Cooper2"),
      (suggestedFloor4: Map[String, Int]) => abs(suggestedFloor4("Smith") - suggestedFloor4("Fletcher4")) != 1,
      (suggestedFloor5: Map[String, Int]) => abs(suggestedFloor5("Fletcher4") - suggestedFloor5("Cooper2")) != 1)

  tenants.permutations.map(_ zip (groundFloor to topFloor)).
    filter(p => exclusions.forall(_(p.toMap))).toList match {
      case Nil => println("No solution")
      case xss => {
        println(s"Solutions: ${xss.size}")
        xss.foreach { l =>
          println("possible solution:")
          l.foreach(p => println(f"${p._1}%11s lives on floor number ${p._2}"))
        }
      }
    }
}
