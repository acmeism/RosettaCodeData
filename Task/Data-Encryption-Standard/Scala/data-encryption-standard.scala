import javax.crypto.Cipher
import javax.crypto.spec.SecretKeySpec

object DataEncryptionStandard extends App {

  private def toHexByteArray(self: String) = {
    val bytes = new Array[Byte](self.length / 2)
    for (i <- bytes.indices)
      bytes(i) = Integer.parseInt(self.substring(i * 2, i * 2 + 2), 16).toByte

    bytes
  }

  private def printHexBytes(self: Array[Byte], label: String): Unit = {
    printf("%s: ", label)
    for (b <- self) {
      val bb = if (b >= 0) b.toInt else b + 256
      var ts = Integer.toString(bb, 16)
      if (ts.length < 2) ts = "0" + ts
      print(ts)
    }
    println()
  }

  val strKey = "0e329232ea6d0d73"
  val keyBytes = toHexByteArray(strKey)
  val key = new SecretKeySpec(keyBytes, "DES")
  val encCipher = Cipher.getInstance("DES")
  encCipher.init(Cipher.ENCRYPT_MODE, key)
  val strPlain = "8787878787878787"
  val plainBytes = toHexByteArray(strPlain)
  val encBytes = encCipher.doFinal(plainBytes)
  printHexBytes(encBytes, "Encoded")
  val decCipher = Cipher.getInstance("DES")
  decCipher.init(Cipher.DECRYPT_MODE, key)
  val decBytes = decCipher.doFinal(encBytes)
  printHexBytes(decBytes, "Decoded")

}
