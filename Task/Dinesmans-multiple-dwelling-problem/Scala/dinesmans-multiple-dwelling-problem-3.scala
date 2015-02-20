import scala.math.abs

object Dinesman2 extends App {
  val groundFloor = 1

  abstract class Rule(val person: String) { val exclusion: Map[String, Int] => Boolean }

  /** Rules with related tenants and restrictions*/
  def rulesDef(topFloor: Int) = List(
    new Rule("Baker") { val exclusion = (_: Map[String, Int])(person) != topFloor },
    new Rule("Cooper2") { val exclusion = (_: Map[String, Int])(person) != groundFloor },
    new Rule("Fletcher4") {
      val exclusion = (suggestedFloor2: Map[String, Int]) => !List(groundFloor, topFloor).contains(suggestedFloor2(person))
    }, new Rule("Miller") {
      val exclusion = (suggestedFloor3: Map[String, Int]) => suggestedFloor3(person) > suggestedFloor3("Cooper2")
    }, new Rule("Smith") {
      val exclusion = (suggestedFloor4: Map[String, Int]) => abs(suggestedFloor4(person) - suggestedFloor4("Fletcher4")) != 1
    }, new Rule("Fletcher4") {
      val exclusion = (suggestedFloor5: Map[String, Int]) => abs(suggestedFloor5(person) - suggestedFloor5("Cooper2")) != 1
    })

  def extensionDef(topFloor: Int) = List(new Rule("Rollo5") {
    val exclusion = (suggestedFloor6: Map[String, Int]) => !List(3, 4, topFloor).contains((suggestedFloor6: Map[String, Int])(person))
  }, new Rule("Rollo5") {
    val exclusion = (suggestedFloor7: Map[String, Int]) => suggestedFloor7(person) < suggestedFloor7("Smith")
  }, new Rule("Rollo5") {
    val exclusion = (suggestedFloor8: Map[String, Int]) => suggestedFloor8(person) > suggestedFloor8("Fletcher4")
  })

  def allRulesDef(topFloor: Int) = rulesDef(topFloor) ++ extensionDef(topFloor)

  val tenants = allRulesDef(0).map(_.person).distinct // Pilot balloon to get # of tenants
  val topFloor = tenants.size
  val exclusions = allRulesDef(topFloor).map(_.exclusion)

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
