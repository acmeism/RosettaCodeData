import java.nio.ByteOrder

object ShowByteOrder extends App {
  println(ByteOrder.nativeOrder())
  println(s"Word size: ${System.getProperty("sun.arch.data.model")}")
  println(s"Endianness: ${System.getProperty("sun.cpu.endian")}")
}
