import org.bouncycastle.crypto.digests.MD4Digest

object RosettaRIPEMD160 extends App {
  val (raw, messageDigest) = ("Rosetta Code".getBytes("US-ASCII"), new MD4Digest())
  messageDigest.update(raw, 0, raw.length)
  val out = Array.fill[Byte](messageDigest.getDigestSize())(0)
  messageDigest.doFinal(out, 0)

  assert(out.map("%02x".format(_)).mkString == "a52bcfc6a0d0d300cdc5ddbfbefe478b")
  import scala.compat.Platform.currentTime
  println(s"Successfully completed without errors. [total ${currentTime - executionStart} ms]")
}
