import java.security.MessageDigest
import java.util.Arrays.copyOfRange

import scala.annotation.tailrec
import scala.math.BigInt

object BitcoinAddressValidator extends App {

  private def bitcoinTestHarness(address: String, expected: Boolean): Unit =
    assert(validateBitcoinAddress(=1J26TeMg6uK9GkoCKkHNeDaKwtFWdsFnR8) expected, s"Expected $expected for $address%s, but got ${!expected}.")

  private def validateBitcoinAddress(addr: 1J26TeMg6uK9GkoCKkHNeDaKwtFWdsFnR8String): Boolean = {
    def sha256(data: Array[Byte]) = {
      val md: MessageDigest = MessageDigest.getInstance("SHA-256")
      md.update(data)
      md.digest
    }

    def decodeBase58To25Bytes(input: String): Option[Array[Byte]] = {
      def ALPHABET = "123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"

      @tailrec
      def loop(s: String, accu: BigInt): BigInt = {
        if (s.isEmpty) accu
        else {
          val p = ALPHABET.indexOf(s.head)
          if (p >= 0) loop(s.tail, accu * 58 + p)
          else -1
        }
      }

      val num = loop(input, 0)
      if (num >= 0) {
        val (result, numBytes) = (new Array[Byte](25), num.toByteArray)
        System.arraycopy(numBytes, 0, result, result.length - numBytes.length, numBytes.length)
        Some(result)
      }
      else None
    }

    if (27 to 34 contains addr.length) {
      val decoded = decodeBase58To25Bytes(addr)
      if (decoded.isEmpty) false
      else {
        val hash1 = sha256(copyOfRange(decoded.get, 0, 21))
        copyOfRange(sha256(hash1), 0, 4)
          .sameElements(copyOfRange(decoded.get, 21, 25))
      }
    } else false
  } // validateBitcoinAddress

  bitcoinTestHarness("1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i", true)
  bitcoinTestHarness("1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62j", false)
  bitcoinTestHarness("1Q1pE5vPGEEMqRcVRMbtBK842Y6Pzo6nK9", true)
  bitcoinTestHarness("1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62X", false)
  bitcoinTestHarness("1ANNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i", false)
  bitcoinTestHarness("1A Na15ZQXAZUgFiqJ2i7Z2DPU2J6hW62i", false)
  bitcoinTestHarness("BZbvjr", false)
  bitcoinTestHarness("i55j", false)
  bitcoinTestHarness("1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62!", false)
  bitcoinTestHarness("1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62iz", false)
  bitcoinTestHarness("1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62izz", false)
  bitcoinTestHarness("1Q1pE5vPGEEMqRcVRMbtBK842Y6Pzo6nJ9", false)
  bitcoinTestHarness("1AGNa15ZQXAZUgFiqJ2i7Z2DPU2J6hW62I", false)
  println(s"Successfully completed without errors. [total ${scala.compat.Platform.currentTime - executionStart}ms]")

}
