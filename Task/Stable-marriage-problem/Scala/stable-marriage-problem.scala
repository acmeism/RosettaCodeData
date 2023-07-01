object SMP extends App {
    private def checkMarriages(): Unit =
        if (check)
            println("Marriages are stable")
        else
            println("Marriages are unstable")

    private def swap() {
        val girl1 = girls.head
        val girl2 = girls(1)
        val tmp = girl2 -> matches(girl1)
        matches += girl1 -> matches(girl2)
        matches += tmp
        println(girl1 + " and " + girl2 + " have switched partners")
    }

    private type TM = scala.collection.mutable.TreeMap[String, String]

    private def check: Boolean = {
        if (!girls.toSet.subsetOf(matches.keySet) || !guys.toSet.subsetOf(matches.values.toSet))
            return false

        val invertedMatches = new TM
        matches foreach { invertedMatches += _.swap }

        for ((k, v) <- matches) {
            val shePrefers = girlPrefers(k)
            val sheLikesBetter = shePrefers.slice(0, shePrefers.indexOf(v))
            val hePrefers = guyPrefers(v)
            val heLikesBetter = hePrefers.slice(0, hePrefers.indexOf(k))

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
    private val guyPrefers = Map("abe" -> List("abi", "eve", "cath", "ivy", "jan", "dee", "fay", "bea", "hope", "gay"),
        "bob" -> List("cath", "hope", "abi", "dee", "eve", "fay", "bea", "jan", "ivy", "gay"),
        "col" -> List("hope", "eve", "abi", "dee", "bea", "fay", "ivy", "gay", "cath", "jan"),
        "dan" -> List("ivy", "fay", "dee", "gay", "hope", "eve", "jan", "bea", "cath", "abi"),
        "ed" -> List("jan", "dee", "bea", "cath", "fay", "eve", "abi", "ivy", "hope", "gay"),
        "fred" -> List("bea", "abi", "dee", "gay", "eve", "ivy", "cath", "jan", "hope", "fay"),
        "gav" -> List("gay", "eve", "ivy", "bea", "cath", "abi", "dee", "hope", "jan", "fay"),
        "hal" -> List("abi", "eve", "hope", "fay", "ivy", "cath", "jan", "bea", "gay", "dee"),
        "ian" -> List("hope", "cath", "dee", "gay", "bea", "abi", "fay", "ivy", "jan", "eve"),
        "jon" -> List("abi", "fay", "jan", "gay", "eve", "bea", "dee", "cath", "ivy", "hope"))
    private val girlPrefers = Map("abi" -> List("bob", "fred", "jon", "gav", "ian", "abe", "dan", "ed", "col", "hal"),
        "bea" -> List("bob", "abe", "col", "fred", "gav", "dan", "ian", "ed", "jon", "hal"),
        "cath" -> List("fred", "bob", "ed", "gav", "hal", "col", "ian", "abe", "dan", "jon"),
        "dee" -> List("fred", "jon", "col", "abe", "ian", "hal", "gav", "dan", "bob", "ed"),
        "eve" -> List("jon", "hal", "fred", "dan", "abe", "gav", "col", "ed", "ian", "bob"),
        "fay" -> List("bob", "abe", "ed", "ian", "jon", "dan", "fred", "gav", "col", "hal"),
        "gay" -> List("jon", "gav", "hal", "fred", "bob", "abe", "col", "ed", "dan", "ian"),
        "hope" -> List("gav", "jon", "bob", "abe", "ian", "dan", "hal", "ed", "col", "fred"),
        "ivy" -> List("ian", "col", "hal", "gav", "fred", "bob", "abe", "ed", "jon", "dan"),
        "jan" -> List("ed", "hal", "gav", "abe", "bob", "jon", "col", "ian", "fred", "dan"))

    private lazy val matches = {
        val engagements = new TM
        val freeGuys = scala.collection.mutable.Queue.empty ++ guys
        while (freeGuys.nonEmpty) {
            val guy = freeGuys.dequeue()
            val guy_p = guyPrefers(guy)
            var break = false
            for (girl <- guy_p)
                if (!break)
                    if (!engagements.contains(girl)) {
                        engagements(girl) = guy
                        break = true
                    }
                    else {
                        val other_guy = engagements(girl)
                        val girl_p = girlPrefers(girl)
                        if (girl_p.indexOf(guy) < girl_p.indexOf(other_guy)) {
                            engagements(girl) = guy
                            freeGuys += other_guy
                            break = true
                        }
                    }
        }

        engagements foreach { e => println(s"${e._1} is engaged to ${e._2}") }
        engagements
    }

    checkMarriages()
    swap()
    checkMarriages()
}
