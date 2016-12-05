import org.bouncycastle.crypto.digests.RIPEMD160Digest
import org.bouncycastle.util.encoders.Hex
import kotlin.text.Charsets.US_ASCII

fun RIPEMD160Digest.inOneGo(input : ByteArray) : ByteArray {
    val output = ByteArray(digestSize)

    update(input, 0, input.size)
    doFinal(output, 0)

    return output
}

fun main(args: Array<String>) {
    val input = "Rosetta Code".toByteArray(US_ASCII)
    val output = RIPEMD160Digest().inOneGo(input)

    Hex.encode(output, System.out)
    System.out.flush()
}
