object RosettaSHA256 extends App {

  def MD5(s: String): String = {
    // Besides "MD5", "SHA-256", and other hashes are available
    val m = java.security.MessageDigest.getInstance("SHA-256").digest(s.getBytes("UTF-8"))
    m.map("%02x".format(_)).mkString
  }

  assert(MD5("Rosetta code") == "764faf5c61ac315f1497f9dfa542713965b785e5cc2f707d6468d7d1124cdfcf")
  println("Successfully completed without errors.")
}
