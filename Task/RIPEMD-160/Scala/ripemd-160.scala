import org.bouncycastle.crypto.digests.RIPEMD160Digest

object RosettaRIPEMD160 extends App {
  val (raw, messageDigest) = ("Rosetta Code".getBytes("US-ASCII"), new RIPEMD160Digest())
  messageDigest.update(raw, 0, raw.length)
  val out = Array.fill[Byte](messageDigest.getDigestSize())(0)
  messageDigest.doFinal(out, 0)

  assert(out.map("%02x".format(_)).mkString == "b3be159860842cebaa7174c8fff0aa9e50a5199f")
}
