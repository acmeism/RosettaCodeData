object FixCodeTags extends App {
  val rx = // See for regex explanation: https://regex101.com/r/N8X4x7/3/
           // Flags ignore case, dot matching line breaks, unicode support
    s"(?is)<(?:(?:code\\s+)?(${langs.mkString("|")}))>(.+?|)<\\/(?:code|\\1)>".r

  def langs = // Real list of langs goes here
    Seq("bar", "baz", "foo", "Scala", "உயிர்/Uyir", "Müller")

  def markDown =
    """Lorem ipsum <Code foo>saepe audire</code> elaboraret ne quo, id equidem
      |atomorum inciderint usu. <foo>In sit inermis deleniti percipit</foo>, ius
      |ex tale civibus omittam. <barf>Vix ut doctus cetero invenire</barf>, his eu
      |altera electram. Tota adhuc altera te sea, <code bar>soluta appetere ut mel
      |</bar>. Quo quis graecis vivendo te, <baz>posse nullam lobortis ex usu</code>.
      |Eam volumus perpetua constituto id, mea an omittam fierent vituperatoribus.
      |Empty element: <Müller></Müller><scaLa></Scala><உயிர்/Uyir></உயிர்/Uyir>""".stripMargin

  println(rx.replaceAllIn(markDown, _ match {
    case rx(langName, langCode) => s"<lang ${langName.capitalize}>${langCode}<${"/lan"}g>"
  })) // ${"/lan"}g is the <noWiki> escape.

}
