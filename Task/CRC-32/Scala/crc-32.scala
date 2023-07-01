import java.util.zip.CRC32
val crc=new CRC32
crc.update("The quick brown fox jumps over the lazy dog".getBytes)
println(crc.getValue.toHexString)  //> 414fa339
