object Main extends App {
    implicit class StrOps(i: String) {
        def isAbbreviationOf(target: String): Boolean = {
            @scala.annotation.tailrec
            def checkPAsPrefixOfM(p: List[Char], m: List[Char]): Boolean = (p, m) match {
                case (Nil, _) => true //prefix empty
                case (_, Nil) => false //main string empty
                case (ph :: pt, mh :: mt) if ph.toUpper == mh.toUpper => checkPAsPrefixOfM(pt, mt) //case insensitive match of head characters
                case _ => false
            }
            i.length >= target.count(_.isUpper) && checkPAsPrefixOfM(i.toList, target.toList)
        }
    }

    val commands = """
              |Add ALTer BAckup Bottom CAppend Change SCHANGE CInsert CLAst COMPress COpy
              |COUnt COVerlay CURsor DELete CDelete Down DUPlicate Xedit EXPand EXTract Find
              |NFind NFINDUp NFUp CFind FINdup FUp FOrward GET Help HEXType Input POWerinput
              |Join SPlit SPLTJOIN LOAD Locate CLocate LOWercase UPPercase LPrefix MACRO
              |MErge MODify MOve MSG Next Overlay PARSE PREServe PURge PUT PUTD Query QUIT
              |READ RECover REFRESH RENum REPeat Replace CReplace RESet RESTore RGTLEFT
              |RIght LEft SAVE SET SHift SI SORT SOS STAck STATus TOP TRAnsfer Type Up
      """.stripMargin.replace("\n", " ").trim.split(" ")

    val input = "riG   rePEAT copies  put mo   rest    types   fup.    6       poweRin".split(" ").filter(!_.isEmpty)

    val resultLine = input.map{ i =>
        commands.find(c => i.isAbbreviationOf(c)).map(_.toUpperCase).getOrElse("*error*")
    }.mkString(" ")

    println(resultLine)
}
