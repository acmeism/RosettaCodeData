package rosetta

object FileExt {

  private val ext = """\.[A-Za-z0-9]+$""".r

  def isExt(fileName: String, extensions: List[String]) =
    extensions.map { _.toLowerCase }.exists { fileName.toLowerCase endsWith "." + _ }

  def extractExt(url: String) = ext findFirstIn url getOrElse("")

}

object FileExtTest extends App {
    val testExtensions: List[String] = List("zip", "rar", "7z", "gz", "archive", "A##", "tar.bz2")

  val isExtTestFiles: Map[String, Boolean] = Map(
      "MyData.a##"          -> true,
      "MyData.tar.Gz"       -> true,
      "MyData.gzip"         -> false,
      "MyData.7z.backup"    -> false,
      "MyData..."           -> false,
      "MyData"              -> false,
      "MyData_v1.0.tar.bz2" -> true,
      "MyData_v1.0.bz2"     -> false
      )

  val extractExtTestFiles: Map[String, String] = Map(
      "http://example.com/download.tar.gz" -> ".gz",
      "CharacterModel.3DS"                 -> ".3DS",
      ".desktop"                           -> ".desktop",
      "document"                           -> "",
      "document.txt_backup"                -> "",
      "/etc/pam.d/login"                   -> "",
      "/etc/pam.d/login.a"                 -> ".a",
      "/etc/pam.d/login."                  -> "",
      "picture.jpg"                        -> ".jpg",
      "http://mywebsite.com/picture/image.png"-> ".png",
      "myuniquefile.longextension"         -> ".longextension",
      "IAmAFileWithoutExtension"           -> "",
      "/path/to.my/file"                   -> "",
      "file.odd_one"                       -> "",
      // Extra, with unicode
	    "café.png"                           -> ".png",
      "file.resumé"                        -> "",
      // with unicode combining characters
	    "cafe\u0301.png"                     -> ".png",
      "file.resume\u0301"                  -> ""
	    )
	      println("isExt() tests:")

  for ((file, isext) <- isExtTestFiles) {
    assert(FileExt.isExt(file, testExtensions) == isext, "Assertion failed for: " + file)
    println("File: " + file + " -> Extension: " + FileExt.extractExt(file))
  }
  println("\nextractExt() tests:")
  for ((url, ext) <- extractExtTestFiles) {
    assert(FileExt.extractExt(url) == ext, "Assertion failed for: " + url)
    println("Url: " + url + " -> Extension: " + FileExt.extractExt(url))
  }
}
