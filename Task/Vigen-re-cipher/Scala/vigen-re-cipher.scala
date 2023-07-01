object Vigenere {
  def encrypt(msg: String, key: String) : String = {
    var result: String = ""
    var j = 0

    for (i <- 0 to msg.length - 1) {
      val c = msg.charAt(i)
      if (c >= 'A' && c <= 'Z') {
        result += ((c + key.charAt(j) - 2 * 'A') % 26 + 'A').toChar
        j = (j + 1) % key.length
      }
    }

    return result
  }

  def decrypt(msg: String, key: String) : String = {
    var result: String = ""
    var j = 0

    for (i <- 0 to msg.length - 1) {
      val c = msg.charAt(i)
      if (c >= 'A' && c <= 'Z') {
        result += ((c - key.charAt(j) + 26) % 26 + 'A').toChar
        j = (j + 1) % key.length
      }
    }

    return result
  }
}

println("Encrypt text ABC => " + Vigenere.encrypt("ABC", "KEY"))
println("Decrypt text KFA => " + Vigenere.decrypt("KFA", "KEY"))
