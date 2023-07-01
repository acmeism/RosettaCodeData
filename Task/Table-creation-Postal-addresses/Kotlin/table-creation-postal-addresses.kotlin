// Version 1.2.41

import java.io.File
import java.io.RandomAccessFile

fun String.toFixedLength(len: Int) = this.padEnd(len).substring(0, len)

class Address(
    var name: String,
    var street: String = "",
    var city: String = "",
    var state: String = "",
    var zipCode: String = "",
    val autoId: Boolean = true
) {
    var id = 0L
        private set

    init {
        if (autoId) id = ++nextId
    }

    companion object {
        private var nextId = 0L

        const val RECORD_LENGTH = 127  // including 2 bytes for UTF string length

        fun readRecord(file: File, id: Long): Address {
            val raf = RandomAccessFile(file, "r")
            val seekPoint = (id - 1) * RECORD_LENGTH
            raf.use {
                it.seek(seekPoint)
                val id2 = it.readLong()
                if (id != id2) {
                    println("Database is corrupt")
                    System.exit(1)
                }
                val text    = it.readUTF()
                val name    = text.substring(0, 30).trimEnd()
                val street  = text.substring(30, 80).trimEnd()
                val city    = text.substring(80, 105).trimEnd()
                val state   = text.substring(105, 107)
                val zipCode = text.substring(107).trimEnd()
                val a = Address(name, street, city, state, zipCode, false)
                a.id = id
                return a
            }
        }
    }

    override fun toString() =
        "Id       : ${this.id}\n" +
        "Name     : $name\n" +
        "Street   : $street\n" +
        "City     : $city\n" +
        "State    : $state\n" +
        "Zip Code : $zipCode\n"

    fun writeRecord(file: File) {
        val raf = RandomAccessFile(file, "rw")
        val text =
            name.toFixedLength(30) +
            street.toFixedLength(50) +
            city.toFixedLength(25) +
            state +
            zipCode.toFixedLength(10)
        val seekPoint = (id - 1) * RECORD_LENGTH
        raf.use {
            it.seek(seekPoint)
            it.writeLong(id)
            it.writeUTF(text)
        }
    }
}

fun main(args: Array<String>) {
    val file = File("addresses.dat")
    val addresses = listOf(
        Address("FSF Inc.", "51 Franklin Street", "Boston", "MA", "02110-1301"),
        Address("The White House", "The Oval Office, 1600 Pennsylvania Avenue NW", "Washington", "DC", "20500")
    )
    // write the address records to the file
    addresses.forEach { it.writeRecord(file) }

    // now read them back in reverse order and print them out
    for (i in 2 downTo 1) {
        println(Address.readRecord(file, i.toLong()))
    }
}
