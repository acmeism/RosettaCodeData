// version 1.2.31

import java.io.File
import java.security.SecureRandom

const val CHARS_PER_LINE = 48
const val CHUNK_SIZE = 6
const val COLS = 8
const val DEMO = true  // would normally be set to false

enum class FileType { OTP, ENC, DEC }

fun Char.isAlpha() = this in 'A'..'Z'

fun String.toAlpha() = this.filter { it.isAlpha() }

fun String.isOtpRelated() = endsWith(".1tp") || endsWith(".1tp_cpy") ||
                            endsWith(".1tp_enc") || endsWith(".1tp_dec")

fun makePad(nLines: Int): String {
    val nChars = nLines * CHARS_PER_LINE
    val sr = SecureRandom()
    val sb = StringBuilder(nChars)
    /* generate random upper case letters */
    for (i in 0 until nChars) sb.append((sr.nextInt(26) + 65).toChar())
    return sb.toString().inChunks(nLines, FileType.OTP)
}

fun vigenere(text: String, key: String, encrypt: Boolean = true): String {
    val sb = StringBuilder(text.length)
    for ((i, c) in text.withIndex()) {
        val ci = if (encrypt)
            (c.toInt() + key[i].toInt() - 130) % 26
        else
            (c.toInt() - key[i].toInt() +  26) % 26
        sb.append((ci + 65).toChar())
    }
    val temp = sb.length % CHARS_PER_LINE
    if (temp > 0) {  // pad with random characters so each line is a full one
        val sr = SecureRandom()
        for (i in temp until CHARS_PER_LINE) sb.append((sr.nextInt(26) + 65).toChar())
    }
    val ft = if (encrypt) FileType.ENC else FileType.DEC
    return sb.toString().inChunks(sb.length / CHARS_PER_LINE, ft)
}

fun String.inChunks(nLines: Int, ft: FileType): String {
    val chunks = this.chunked(CHUNK_SIZE)
    val sb = StringBuilder(this.length + nLines * (COLS + 1))
    for (i in 0 until nLines) {
        val j = i * COLS
        sb.append(" ${chunks.subList(j, j + COLS).joinToString(" ")}\n")
    }
    val s = " file\n" + sb.toString()
    return when (ft) {
        FileType.OTP -> "# OTP" + s
        FileType.ENC -> "# Encrypted" + s
        FileType.DEC -> "# Decrypted" + s
    }
}

fun menu(): Int {
    println("""
        |
        |1. Create one time pad file.
        |
        |2. Delete one time pad file.
        |
        |3. List one time pad files.
        |
        |4. Encrypt plain text.
        |
        |5. Decrypt cipher text.
        |
        |6. Quit program.
        |
        """.trimMargin())
    var choice: Int?
    do {
        print("Your choice (1 to 6) : ")
        choice = readLine()!!.toIntOrNull()
    }
    while (choice == null || choice !in 1..6)
    return choice
}

fun main(args: Array<String>) {
    mainLoop@ while (true) {
        val choice = menu()
        println()
        when (choice) {
            1 -> {  // Create OTP
                println("Note that encrypted lines always contain 48 characters.\n")
                print("OTP file name to create (without extension) : ")
                val fileName = readLine()!! + ".1tp"
                var nLines: Int?

                do {
                    print("Number of lines in OTP (max 1000) : ")
                    nLines = readLine()!!.toIntOrNull()
                }
                while (nLines == null || nLines !in 1..1000)

                val key = makePad(nLines)
                File(fileName).writeText(key)
                println("\n'$fileName' has been created in the current directory.")
                if (DEMO) {
                    // a copy of the OTP file would normally be on a different machine
                    val fileName2 = fileName + "_cpy"  // copy for decryption
                    File(fileName2).writeText(key)
                    println("'$fileName2' has been created in the current directory.")
                    println("\nThe contents of these files are :\n")
                    println(key)
                }
            }

            2 -> {  // Delete OTP
                println("Note that this will also delete ALL associated files.\n")
                print("OTP file name to delete (without extension) : ")
                val toDelete1 = readLine()!! + ".1tp"
                val toDelete2 = toDelete1 + "_cpy"
                val toDelete3 = toDelete1 + "_enc"
                val toDelete4 = toDelete1 + "_dec"
                val allToDelete = listOf(toDelete1, toDelete2, toDelete3, toDelete4)
                var deleted = 0
                println()
                for (name in allToDelete) {
                    val f = File(name)
                    if (f.exists()) {
                        f.delete()
                        deleted++
                        println("'$name' has been deleted from the current directory.")
                    }
                }
                if (deleted == 0) println("There are no files to delete.")
            }

            3 -> {  // List OTPs
                println("The OTP (and related) files in the current directory are:\n")
                val otpFiles = File(".").listFiles().filter {
                    it.isFile() && it.name.isOtpRelated()
                }.map { it.name }.toMutableList()
                otpFiles.sort()
                println(otpFiles.joinToString("\n"))
            }

            4 -> {  // Encrypt
                print("OTP file name to use (without extension) : ")
                val keyFile = readLine()!! + ".1tp"
                val kf = File(keyFile)
                if (kf.exists()) {
                    val lines = File(keyFile).readLines().toMutableList()
                    var first = lines.size
                    for (i in 0 until lines.size) {
                        if (lines[i].startsWith(" ")) {
                            first = i
                            break
                        }
                    }
                    if (first == lines.size) {
                        println("\nThat file has no unused lines.")
                        continue@mainLoop
                    }
                    val lines2 = lines.drop(first)  // get rid of comments and used lines

                    println("Text to encrypt :-\n")
                    val text = readLine()!!.toUpperCase().toAlpha()
                    val len = text.length
                    var nLines = len / CHARS_PER_LINE
                    if (len % CHARS_PER_LINE > 0) nLines++

                    if (lines2.size >= nLines) {
                        val key = lines2.take(nLines).joinToString("").toAlpha()
                        val encrypted = vigenere(text, key)
                        val encFile = keyFile + "_enc"
                        File(encFile).writeText(encrypted)
                        println("\n'$encFile' has been created in the current directory.")
                        for (i in first until first + nLines) {
                            lines[i] = "-" + lines[i].drop(1)
                        }
                        File(keyFile).writeText(lines.joinToString("\n"))
                        if (DEMO) {
                            println("\nThe contents of the encrypted file are :\n")
                            println(encrypted)
                        }
                    }
                    else println("Not enough lines left in that file to do encryption")
                }
                else println("\nThat file does not exist.")
            }

            5 -> {  // Decrypt
                print("OTP file name to use (without extension) : ")
                val keyFile = readLine()!! + ".1tp_cpy"
                val kf = File(keyFile)
                if (kf.exists()) {
                    val keyLines = File(keyFile).readLines().toMutableList()
                    var first = keyLines.size
                    for (i in 0 until keyLines.size) {
                        if (keyLines[i].startsWith(" ")) {
                            first = i
                            break
                        }
                    }
                    if (first == keyLines.size) {
                        println("\nThat file has no unused lines.")
                        continue@mainLoop
                    }
                    val keyLines2 = keyLines.drop(first)  // get rid of comments and used lines

                    val encFile = keyFile.dropLast(3) + "enc"
                    val ef = File(encFile)
                    if (ef.exists()) {
                        val encLines = File(encFile).readLines().drop(1)  // exclude comment line
                        val nLines = encLines.size
                        if (keyLines2.size >= nLines) {
                            val encrypted = encLines.joinToString("").toAlpha()
                            val key = keyLines2.take(nLines).joinToString("").toAlpha()
                            val decrypted = vigenere(encrypted, key, false)
                            val decFile = keyFile.dropLast(3) + "dec"
                            File(decFile).writeText(decrypted)
                            println("\n'$decFile' has been created in the current directory.")
                            for (i in first until first + nLines) {
                                keyLines[i] = "-" + keyLines[i].drop(1)
                            }
                            File(keyFile).writeText(keyLines.joinToString("\n"))
                            if (DEMO) {
                                println("\nThe contents of the decrypted file are :\n")
                                println(decrypted)
                            }
                        }
                        else println("Not enough lines left in that file to do decryption")
                    }
                    else println("\n'$encFile' is missing.")
                }
                else println("\nThat file does not exist.")
            }

            else -> return  // Quit
        }
    }
}
