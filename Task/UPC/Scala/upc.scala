object UPC {
  private val SEVEN = 7

  private val LEFT_DIGITS = Map(
    "   ## #" -> 0,
    "  ##  #" -> 1,
    "  #  ##" -> 2,
    " #### #" -> 3,
    " #   ##" -> 4,
    " ##   #" -> 5,
    " # ####" -> 6,
    " ### ##" -> 7,
    " ## ###" -> 8,
    "   # ##" -> 9
  )

  private val RIGHT_DIGITS = LEFT_DIGITS.map { case (key, value) =>
    key.replace(' ', 's').replace('#', ' ').replace('s', '#') -> value
  }

  private val END_SENTINEL = "# #"
  private val MID_SENTINEL = " # # "

  private def decode(candidate: String): (Boolean, List[Int]) = {
    var pos = 0
    val output = scala.collection.mutable.ListBuffer[Int]()

    // Check start sentinel
    if (candidate.length < pos + END_SENTINEL.length ||
        candidate.substring(pos, pos + END_SENTINEL.length) != END_SENTINEL) {
      return (false, output.toList)
    }
    pos += END_SENTINEL.length

    // Decode left side digits
    for (_ <- 1 until SEVEN) {
      if (candidate.length < pos + SEVEN) {
        return (false, output.toList)
      }
      val part = candidate.substring(pos, pos + SEVEN)
      pos += SEVEN

      LEFT_DIGITS.get(part) match {
        case Some(digit) => output += digit
        case None => return (false, output.toList)
      }
    }

    // Check middle sentinel
    if (candidate.length < pos + MID_SENTINEL.length ||
        candidate.substring(pos, pos + MID_SENTINEL.length) != MID_SENTINEL) {
      return (false, output.toList)
    }
    pos += MID_SENTINEL.length

    // Decode right side digits
    for (_ <- 1 until SEVEN) {
      if (candidate.length < pos + SEVEN) {
        return (false, output.toList)
      }
      val part = candidate.substring(pos, pos + SEVEN)
      pos += SEVEN

      RIGHT_DIGITS.get(part) match {
        case Some(digit) => output += digit
        case None => return (false, output.toList)
      }
    }

    // Check end sentinel
    if (candidate.length < pos + END_SENTINEL.length ||
        candidate.substring(pos, pos + END_SENTINEL.length) != END_SENTINEL) {
      return (false, output.toList)
    }

    // Calculate checksum
    val sum = output.zipWithIndex.map { case (digit, index) =>
      if (index % 2 == 0) 3 * digit else digit
    }.sum

    (sum % 10 == 0, output.toList)
  }

  private def printList(list: List[Int]): Unit = {
    print("[")
    print(list.mkString(", "))
    print("]")
  }

  private def decodeUPC(input: String): Unit = {
    val candidate = input.trim
    val (isValid, digits) = decode(candidate)

    if (isValid) {
      printList(digits)
      println()
    } else {
      // Try upside down
      val reversed = candidate.reverse
      val (isValidReversed, digitsReversed) = decode(reversed)

      if (isValidReversed) {
        printList(digitsReversed)
        println(" Upside down")
      } else if (digitsReversed.length == 12) {
        println("Invalid checksum")
      } else {
        println("Invalid digit(s)")
      }
    }
  }

  def main(args: Array[String]): Unit = {
    val barcodes = List(
      "         # #   # ##  #  ## #   ## ### ## ### ## #### # # # ## ##  #   #  ##  ## ###  # ##  ## ### #  # #       ",
      "        # # #   ##   ## # #### #   # ## #   ## #   ## # # # ###  # ###  ##  ## ###  # #  ### ###  # # #         ",
      "         # #    # # #  ###  #   #    # #  #   #    # # # # ## #   ## #   ## #   ##   # # #### ### ## # #         ",
      "       # # ##  ## ##  ##   #  #   #  # ###  # ##  ## # # #   ## ##  #  ### ## ## #   # #### ## #   # #        ",
      "         # # ### ## #   ## ## ###  ##  # ##   #   # ## # # ### #  ## ##  #    # ### #  ## ##  #      # #          ",
      "          # #  #   # ##  ##  #   #   #  # ##  ##  #   # # # # #### #  ##  # #### #### # #  ##  # #### # #         ",
      "         # #  #  ##  ##  # #   ## ##   # ### ## ##   # # # #  #   #   #  #  ### # #    ###  # #  #   # #        ",
      "        # # #    # ##  ##   #  # ##  ##  ### #   #  # # # ### ## ## ### ## ### ### ## #  ##  ### ## # #         ",
      "         # # ### ##   ## # # #### #   ## # #### # #### # # #   #  # ###  #    # ###  # #    # ###  # # #       ",
      "        # # # #### ##   # #### # #   ## ## ### #### # # # #  ### # ###  ###  # # ###  #    # #  ### # #         "
    )

    barcodes.foreach(decodeUPC)
  }
}
