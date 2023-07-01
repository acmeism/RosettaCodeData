object MD5 extends App {

  def hash(s: String) = {
    def b = s.getBytes("UTF-8")

    def m = java.security.MessageDigest.getInstance("MD5").digest(b)

    BigInt(1, m).toString(16).reverse.padTo(32, "0").reverse.mkString
  }

  assert("d41d8cd98f00b204e9800998ecf8427e" == hash(""))
  assert("0000045c5e2b3911eb937d9d8c574f09" == hash("iwrupvqb346386"))
  assert("0cc175b9c0f1b6a831c399e269772661" == hash("a"))
  assert("900150983cd24fb0d6963f7d28e17f72" == hash("abc"))
  assert("f96b697d7cb7938d525a2f31aaf161d0" == hash("message digest"))
  assert("c3fcd3d76192e4007dfb496cca67e13b" == hash("abcdefghijklmnopqrstuvwxyz"))
  assert("d174ab98d277d9f5a5611c2c9f419d9f" == hash("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"))
  assert("57edf4a22be3c955ac49da2e2107b67a" == hash("12345678901234567890123456789012345678901234567890123456789012345678901234567890"))

}
