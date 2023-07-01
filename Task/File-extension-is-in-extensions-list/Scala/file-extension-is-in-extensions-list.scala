  def isExt(fileName: String, extensions: List[String]): Boolean = {
    extensions.map { _.toLowerCase }.exists { fileName.toLowerCase endsWith "." + _ }
  }
