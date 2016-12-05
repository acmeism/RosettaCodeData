import java.util._
import scala.collection.JavaConversions._

object SMP extends App {
  def run() {
    Seq("abe" -> Array("abi", "eve", "cath", "ivy", "jan", "dee", "fay", "bea", "hope", "gay"),
      "bob" -> Array("cath", "hope", "abi", "dee", "eve", "fay", "bea", "jan", "ivy", "gay"),
      "col" -> Array("hope", "eve", "abi", "dee", "bea", "fay", "ivy", "gay", "cath", "jan"),
      "dan" -> Array("ivy", "fay", "dee", "gay", "hope", "eve", "jan", "bea", "cath", "abi"),
      "ed" -> Array("jan", "dee", "bea", "cath", "fay", "eve", "abi", "ivy", "hope", "gay"),
      "fred" -> Array("bea", "abi", "dee", "gay", "eve", "ivy", "cath", "jan", "hope", "fay"),
      "gav" -> Array("gay", "eve", "ivy", "bea", "cath", "abi", "dee", "hope", "jan", "fay"),
      "hal" -> Array("abi", "eve", "hope", "fay", "ivy", "cath", "jan", "bea", "gay", "dee"),
      "ian" -> Array("hope", "cath", "dee", "gay", "bea", "abi", "fay", "ivy", "jan", "eve"),
      "jon" -> Array("abi", "fay", "jan", "gay", "eve", "bea", "dee", "cath", "ivy", "hope"))
      .foreach { e => guyPrefers.put(e._1, e._2.toList) }

    Seq("abi" -> Array("bob", "fred", "jon", "gav", "ian", "abe", "dan", "ed", "col", "hal"),
      "bea" -> Array("bob", "abe", "col", "fred", "gav", "dan", "ian", "ed", "jon", "hal"),
      "cath" -> Array("fred", "bob", "ed", "gav", "hal", "col", "ian", "abe", "dan", "jon"),
      "dee" -> Array("fred", "jon", "col", "abe", "ian", "hal", "gav", "dan", "bob", "ed"),
      "eve" -> Array("jon", "hal", "fred", "dan", "abe", "gav", "col", "ed", "ian", "bob"),
      "fay" -> Array("bob", "abe", "ed", "ian", "jon", "dan", "fred", "gav", "col", "hal"),
      "gay" -> Array("jon", "gav", "hal", "fred", "bob", "abe", "col", "ed", "dan", "ian"),
      "hope" -> Array("gav", "jon", "bob", "abe", "ian", "dan", "hal", "ed", "col", "fred"),
      "ivy" -> Array("ian", "col", "hal", "gav", "fred", "bob", "abe", "ed", "jon", "dan"),
      "jan" -> Array("ed", "hal", "gav", "abe", "bob", "jon", "col", "ian", "fred", "dan"))
      .foreach { e => girlPrefers.put(e._1, e._2.toList) }

    val matches = matching(guys, guyPrefers, girlPrefers)
    matches.foreach { e => println(s"${e._1} is engaged to ${e._2}") }
    if (checkMatches(guys, girls, matches, guyPrefers, girlPrefers))
      println("Marriages are stable")
    else
      println("Marriages are unstable")

    val tmp = matches(girls(0))
    matches += girls(0) -> matches(girls(1))
    matches += girls(1) -> tmp
    println(girls(0) + " and " + girls(1) + " have switched partners")
    if (checkMatches(guys, girls, matches, guyPrefers, girlPrefers))
      println("Marriages are stable")
    else
      println("Marriages are unstable")
  }

  private def matching(guys: Iterable[String],
                       guyPrefers: Map[String, List[String]],
                       girlPrefers: Map[String, List[String]]): Map[String, String] = {
    val engagements = new TreeMap[String, String]
    val freeGuys = new LinkedList[String](guys)
    while (!freeGuys.isEmpty) {
      val guy = freeGuys.remove(0)
      val guy_p = guyPrefers(guy)
      var break = false
      for (girl <- guy_p)
        if (!break)
          if (!engagements.containsKey(girl)) {
            engagements += girl -> guy
            break = true
          }
          else {
            val other_guy = engagements(girl)
            val girl_p = girlPrefers(girl)
            if (girl_p.indexOf(guy) < girl_p.indexOf(other_guy)) {
              engagements += girl -> guy
              freeGuys += other_guy
              break = true
            }
          }
    }

    engagements
  }

  private def checkMatches(guys: Iterable[String], girls: Iterable[String],
                           matches: Map[String, String],
                           guyPrefers: Map[String, List[String]],
                           girlPrefers: Map[String, List[String]]): Boolean = {
    if (!matches.keySet.containsAll(girls) || !matches.values.containsAll(guys))
      return false

    val invertedMatches = new TreeMap[String, String]
    matches.foreach { invertedMatches += _.swap }

    for ((k, v) <- matches) {
      val shePrefers = girlPrefers(k)
      val sheLikesBetter = new LinkedList[String]
      sheLikesBetter.addAll(shePrefers.subList(0, shePrefers.indexOf(v)))
      val hePrefers = guyPrefers(v)
      val heLikesBetter = new LinkedList[String]
      heLikesBetter.addAll(hePrefers.subList(0, hePrefers.indexOf(k)))

      for (guy <- sheLikesBetter) {
        val fiance = invertedMatches(guy)
        val guy_p = guyPrefers(guy)
        if (guy_p.indexOf(fiance) > guy_p.indexOf(k)) {
          println(s"$k likes $guy better than $v and $guy likes $k better than their current partner")
          return false
        }
      }

      for (girl <- heLikesBetter) {
        val fiance = matches(girl)
        val girl_p = girlPrefers(girl)
        if (girl_p.indexOf(fiance) > girl_p.indexOf(v)) {
          println(s"$v likes $girl better than $k and $girl likes $v better than their current partner")
          return false
        }
      }
    }
    true
  }

  private val guys = "abe" :: "bob" :: "col" :: "dan" :: "ed" :: "fred" :: "gav" :: "hal" :: "ian" :: "jon" :: Nil
  private val girls = "abi" :: "bea" :: "cath" :: "dee" :: "eve" :: "fay" :: "gay" :: "hope" :: "ivy" :: "jan" :: Nil
  private val guyPrefers = new HashMap[String, List[String]]
  private val girlPrefers = new HashMap[String, List[String]]

  run()
}
