// version 1.1.4-3

import java.util.Random
import java.io.File

val r = Random()
val rr = Random()  // use a separate generator for shuffles
val ls = System.getProperty("line.separator")

var lower = "abcdefghijklmnopqrstuvwxyz"
var upper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
var digit = "0123456789"
var other = """!"#$%&'()*+,-./:;<=>?@[]^_{|}~"""

val exclChars = arrayOf(
    "'I', 'l' and '1'",
    "'O' and '0'     ",
    "'5' and 'S'     ",
    "'2' and 'Z'     "
)

fun String.shuffle(): String {
    val sb = StringBuilder(this)
    var n = sb.length
    while (n > 1) {
        val k = rr.nextInt(n--)
        val t = sb[n]
        sb[n] = sb[k]
        sb[k] = t
    }
    return sb.toString()
}

fun generatePasswords(pwdLen: Int, pwdNum: Int, toConsole: Boolean, toFile: Boolean) {
    val sb = StringBuilder()
    val ll = lower.length
    val ul = upper.length
    val dl = digit.length
    val ol = other.length
    val tl = ll + ul + dl + ol
    var fw = if (toFile) File("pwds.txt").writer() else null

    if (toConsole) println("\nThe generated passwords are:")
    for (i in 0 until pwdNum) {
        sb.setLength(0)
        sb.append(lower[r.nextInt(ll)])
        sb.append(upper[r.nextInt(ul)])
        sb.append(digit[r.nextInt(dl)])
        sb.append(other[r.nextInt(ol)])

        for (j in 0 until pwdLen - 4) {
            val k = r.nextInt(tl)
            sb.append(when (k) {
                in 0 until ll -> lower[k]
                in ll until ll + ul -> upper[k - ll]
                in ll + ul until tl - ol -> digit[k - ll - ul]
                else -> other[tl - 1 - k]
            })
        }
        var pwd = sb.toString()
        repeat(5) { pwd = pwd.shuffle() } // shuffle 5 times say
        if (toConsole) println("  ${"%2d".format(i + 1)}:  $pwd")
        if (toFile) {
            fw!!.write(pwd)
            if (i < pwdNum - 1) fw.write(ls)
        }
    }
    if (toFile) {
       println("\nThe generated passwords have been written to the file pwds.txt")
       fw!!.close()
    }
}

fun printHelp() {
    println("""
        |This program generates up to 99 passwords of between 5 and 20 characters in
        |length.
        |
        |You will be prompted for the values of all parameters when the program is run
        |- there are no command line options to memorize.
        |
        |The passwords can either be written to the console or to a file (pwds.txt),
        |or both.
        |
        |The passwords must contain at least one each of the following character types:
        |   lower-case letters :  a -> z
        |   upper-case letters :  A -> Z
        |   digits             :  0 -> 9
        |   other characters   :  !"#$%&'()*+,-./:;<=>?@[]^_{|}~
        |
        |Optionally, a seed can be set for the random generator
        |(any non-zero Long integer) otherwise the default seed will be used.
        |Even if the same seed is set, the passwords won't necessarily be exactly
        |the same on each run as additional random shuffles are always performed.
        |
        |You can also specify that various sets of visually similar characters
        |will be excluded (or not) from the passwords, namely: Il1  O0  5S  2Z
        |
        |Finally, the only command line options permitted are -h and -help which
        |will display this page and then exit.
        |
        |Any other command line parameters will simply be ignored and the program
        |will be run normally.
        |
    """.trimMargin())
}

fun main(args: Array<String>) {
    if (args.size == 1 && (args[0] == "-h" || args[0] == "-help")) {
       printHelp()
       return
    }

    println("Please enter the following and press return after each one")

    var pwdLen: Int?
    do {
       print("  Password length (5 to 20)     : ")
       pwdLen = readLine()!!.toIntOrNull() ?: 0
    }
    while (pwdLen !in 5..20)

    var pwdNum: Int?
    do {
       print("  Number to generate (1 to 99)  : ")
       pwdNum = readLine()!!.toIntOrNull() ?: 0
    }
    while (pwdNum !in 1..99)

    var seed: Long?
    do {
       print("  Seed value (0 to use default) : ")
       seed = readLine()!!.toLongOrNull()
    }
    while (seed == null)
    if (seed != 0L) r.setSeed(seed)

    println("  Exclude the following visually similar characters")
    for (i in 0..3) {
        var yn: String
        do {
            print("    ${exclChars[i]} y/n : ")
            yn = readLine()!!.toLowerCase()
        }
        while (yn != "y" && yn != "n")
        if (yn == "y") {
            when (i) {
                0 -> {
                    upper = upper.replace("I", "")
                    lower = lower.replace("l", "")
                    digit = digit.replace("1", "")
                }

                1 -> {
                    upper = upper.replace("O", "")
                    digit = digit.replace("0", "")
                }

                2 -> {
                    upper = upper.replace("S", "")
                    digit = digit.replace("5", "")
                }

                3 -> {
                    upper = upper.replace("Z", "")
                    digit = digit.replace("2", "")
                }
            }
        }
    }

    var toConsole: Boolean?
    do {
        print("  Write to console   y/n : ")
        val t = readLine()!!
        toConsole = if (t == "y") true else if (t == "n") false else null
    }
    while (toConsole == null)

    var toFile: Boolean? = true
    if (toConsole) {
        do {
            print("  Write to file      y/n : ")
            val t = readLine()!!
            toFile = if (t == "y") true else if (t == "n") false else null
        }
        while (toFile == null)
    }

    generatePasswords(pwdLen!!, pwdNum!!, toConsole, toFile!!)
}
