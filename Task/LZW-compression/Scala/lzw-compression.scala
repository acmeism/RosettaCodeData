def compress(tc:String) = {
    //initial dictionary
    val startDict = (1 to 255).map(a=>(""+a.toChar,a)).toMap
    val (fullDict, result, remain) = tc.foldLeft ((startDict, List[Int](), "")) {
      case ((dict,res,leftOver),nextChar) =>
        if (dict.contains(leftOver + nextChar)) // current substring already in dict
          (dict, res, leftOver+nextChar)
        else if (dict.size < 4096) // add to dictionary
          (dict + ((leftOver+nextChar, dict.size+1)), dict(leftOver) :: res, ""+nextChar)
        else // dictionary is full
          (dict, dict(leftOver) :: res, ""+nextChar)
    }
    if (remain.isEmpty) result.reverse else (fullDict(remain) :: result).reverse
}

def decompress(ns: List[Int]): String = {
  val startDict = (1 to 255).map(a=>(a,""+a.toChar)).toMap
  val (_, result, _) =
    ns.foldLeft[(Map[Int, String], List[String], Option[(Int, String)])]((startDict, Nil, None)) {
    case ((dict, result, conjecture), n) => {
      dict.get(n) match {
        case Some(output) => {
          val (newDict, newCode) = conjecture match {
            case Some((code, prefix)) => ((dict + (code -> (prefix + output.head))), code + 1)
            case None => (dict, dict.size + 1)
          }
          (newDict, output :: result, Some(newCode -> output))
        }
        case None => {
          // conjecture being None would be an encoding error
          val (code, prefix) = conjecture.get
          val output = prefix + prefix.head
          (dict + (code -> output), output :: result, Some(code + 1 -> output))
        }
      }
    }
  }
  result.reverse.mkString("")
}
// test
val text = "TOBEORNOTTOBEORTOBEORNOT"
val compressed = compress(text)
println(compressed)
val result = decompress(compressed)
println(result)
