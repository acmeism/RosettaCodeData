def scrapeRosettaCodeLanguageRanks() : Seq[(String,Int)] = {

  //
  // The Programming Languages
  //
  val langs = {
    val langsXML = scala.xml.XML.load("http://rosettacode.org/mw/api.php?action=query&list=categorymembers&cmtitle=Category:Programming_Languages&cmlimit=500&format=xml")

    (langsXML \\ "categorymembers" \ "cm") map (c => (c \ "@title").text)
  }

  //
  // The Categories
  //
  val cats = {
	
    // The categories include a page for the language and a count of the pages linked
    // therein, this count is the data we need to scrape.
    val catsXML = scala.xml.XML.load("http://rosettacode.org/mw/index.php?title=Special:Categories&limit=5000")

    (catsXML \\ "ul" \ "li") map {c =>

      // Create a tuple pair, eg. ("Category:Erlang", 195)
      (
        (c \ "a" \ "@title").toString,
        ("[0-9]+".r.findFirstIn((c.child.drop(1)).text).getOrElse("0").toInt)  // Takes the sibling of "a" and extracts the number
      )
    }
  }

  val ranks = ((langs map { s => cats.find( c => (c._1 == s) ) }).flatten) map {e =>

    // Clean up the tuple pairs, eg ("Category:Erlang", 195) becomes ("Erlang", 192)
    (
      (if( e._1.contains("Category:") ) e._1.split("Category:")(1) else e._1),
      ((e._2 - 3) max 0)  // 3 members (or links) are not of a task
    )
  } sortBy ( - _._2 )

  ranks
}

val ranks = scrapeRosettaCodeLanguageRanks()

println("Top 50 Rosetta Code Languages by Popularity, %tF:".format(new java.util.Date) + "\n" )
ranks.take(50).zipWithIndex foreach {case ((lang,rank),i) => println( s"${i+1}. $rank - $lang" )}
