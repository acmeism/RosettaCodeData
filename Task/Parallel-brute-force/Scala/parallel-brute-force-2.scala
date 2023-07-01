import java.security.MessageDigest

import scala.annotation.tailrec
import scala.collection.parallel.immutable.ParVector

object EncryptionCracker {
  def main(args: Array[String]): Unit = {
    val hash1 = "1115dd800feaacefdf481f1f9070374a2a81e27880f187396db67958b207cbad"
    val hash2 = "3a7bd3e2360a3d29eea436fcfb7e44c735d117c42d1c1835420b6b9942dd4f1b"
    val hash3 = "74e1bb62f8dabb8125a58852b63bdf6eaef667cb56ac7f7cdba6d7305c50a22f"

    val charSet = ('a' to 'z').toVector
    val len = 5
    val num = 1000000

    for(tmp <- List(hash1, hash2, hash3)){
      println(tmp)
      crackLazy(tmp, charSet, len, num) match{
        case Some(s) => println(s"String: $s\n")
        case None => println("Failed\n")
      }
    }
  }

  def crackLazy(hash: String, charSet: Vector[Char], len: Int, num: Int): Option[String] = {
    @tailrec
    def getMatch(lst: LazyList[String]): Option[String] = {
      def hit = lst.take(num).to(ParVector).find(str => getHash(str).equalsIgnoreCase(hash))
      def nxt = lst.drop(num)
      hit match{
        case Some(str) => Some(str)
        case None if nxt.nonEmpty => getMatch(nxt)
        case None => None
      }
    }

    def perms = charSet
      .flatMap(Vector.fill(len)(_))
      .combinations(len)
      .flatMap(_.permutations.map(_.mkString)).to(LazyList)

    getMatch(perms)
  }

  def getHash(str: String): String = {
    val digester = MessageDigest.getInstance("SHA-256")
    digester.digest(str.getBytes("UTF-8")).map("%02x".format(_)).mkString
  }
}
