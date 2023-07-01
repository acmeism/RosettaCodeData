object RosettaMD5 extends App {

  def MD5(s: String): String = {
    // Besides "MD5", "SHA-256", and other hashes are available
    val m = java.security.MessageDigest.getInstance("MD5").digest(s.getBytes("UTF-8"))
    m.map("%02x".format(_)).mkString
  }

  assert("d41d8cd98f00b204e9800998ecf8427e" == MD5(""))
  assert("0cc175b9c0f1b6a831c399e269772661" == MD5("a"))
  assert("900150983cd24fb0d6963f7d28e17f72" == MD5("abc"))
  assert("f96b697d7cb7938d525a2f31aaf161d0" == MD5("message digest"))
  assert("c3fcd3d76192e4007dfb496cca67e13b" == MD5("abcdefghijklmnopqrstuvwxyz"))
  assert("e38ca1d920c4b8b8d3946b2c72f01680" == MD5("The quick brown fox jumped over the lazy dog's back"))
  assert("d174ab98d277d9f5a5611c2c9f419d9f" ==
    MD5("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"))
  assert("57edf4a22be3c955ac49da2e2107b67a" ==
    MD5("12345678901234567890123456789012345678901234567890123456789012345678901234567890"))
  import scala.compat.Platform.currentTime
  println(s"Successfully completed without errors. [total ${currentTime - executionStart} ms]")
}
