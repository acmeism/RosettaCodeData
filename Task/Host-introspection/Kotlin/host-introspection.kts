// version 1.0.6

fun main(args: Array<String>) {
    println("Word size : ${System.getProperty("sun.arch.data.model")} bits")
    println("Endianness: ${System.getProperty("sun.cpu.endian")}-endian")
}
