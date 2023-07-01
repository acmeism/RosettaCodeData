import java.security.MessageDigest

import scala.collection.parallel.immutable.ParVector

object EncryptionCracker {
  def main(args: Array[String]): Unit = {
    val hash1 = "1115dd800feaacefdf481f1f9070374a2a81e27880f187396db67958b207cbad"
    val hash2 = "3a7bd3e2360a3d29eea436fcfb7e44c735d117c42d1c1835420b6b9942dd4f1b"
    val hash3 = "74e1bb62f8dabb8125a58852b63bdf6eaef667cb56ac7f7cdba6d7305c50a22f"

    val cracker: String => Option[String] = crackLazy('a' to 'z', 5, 1000000)

    for(tmp <- Seq(hash2, hash1, hash3)){
      println(s"$tmp")
      cracker(tmp) match{
        case Some(s) => println(s"String: $s\n")
        case None => println("Failed\n")
      }
    }
  }

  def getHash(str: String): String = MessageDigest
    .getInstance("SHA-256")
    .digest(str.getBytes("UTF-8"))
    .map("%02x".format(_)).mkString

  def crackLazy(charSet: Seq[Char], len: Int, num: Int)(hash: String): Option[String] = charSet
    .flatMap(Vector.fill(len)(_))                           //Duplicate characters so they can be used any number of times
    .combinations(len)                                      //Generate distinct sets of characters
    .flatMap(_.permutations.map(_.mkString))                //Generate all permutations for each character set
    .grouped(num)                                           //Partition into bite-size chunks
    .map(_.to(ParVector).find(str => getHash(str) == hash)) //Convert each chunk into a ParVector and search it
    .collectFirst{case Some(res) => res}                    //Get the first hit if one is found
}
