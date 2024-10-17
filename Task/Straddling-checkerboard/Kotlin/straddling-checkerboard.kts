// version 1.2.0

val board = "ET AON RISBCDFGHJKLMPQ/UVWXYZ."
val digits = "0123456789"
val rows = " 26"
val escape = "62"
val key = "0452"

fun encrypt(message: String): String {
    val msg = message.toUpperCase()
                     .filter { (it in board || it in digits) && it !in " /" }
    val sb = StringBuilder()
    for (c in msg) {
        val idx = board.indexOf(c)
        if (idx > -1) {
            val row = idx / 10
            val col = idx % 10
            sb.append(if (row == 0) "$col" else "${rows[row]}$col")
        }
        else {
            sb.append("$escape$c")
        }
    }
    val enc = sb.toString().toCharArray()
    for ((i, c) in enc.withIndex()) {
        val k = key[i % 4] - '0'
        if (k == 0) continue
        val j = c - '0'
        enc[i] = '0' + ((j + k) % 10)
    }
    return String(enc)
}

fun decrypt(encoded: String): String {
    val enc = encoded.toCharArray()
    for ((i, c) in enc.withIndex()) {
        val k = key[i % 4] - '0'
        if (k == 0) continue
        val j = c - '0'
        enc[i] = '0' + if (j >= k) (j - k) % 10 else (10 + j - k) % 10
    }
    val len = enc.size
    val sb = StringBuilder()
    var i = 0
    while (i < len) {
        val c = enc[i]
        val idx = rows.indexOf(c)
        if (idx == -1) {
            val idx2 = c - '0'
            sb.append(board[idx2])
            i++
        }
        else if ("$c${enc[i + 1]}" == escape) {
            sb.append(enc[i + 2])
            i += 3
        }
        else {
            val idx2 = idx * 10 + (enc[i + 1] - '0')
            sb.append(board[idx2])
            i += 2
        }
    }
    return sb.toString()
}

fun main(args: Array<String>) {
    val messages = listOf(
        "Attack at dawn",
        "One night-it was on the twentieth of March, 1888-I was returning",
        "In the winter 1965/we were hungry/just barely alive",
        "you have put on 7.5 pounds since I saw you.",
        "The checkerboard cake recipe specifies 3 large eggs and 2.25 cups of flour."
    )
    for (message in messages) {
        val encrypted = encrypt(message)
        val decrypted = decrypt(encrypted)
        println("\nMessage   : $message")
        println("Encrypted : $encrypted")
        println("Decrypted : $decrypted")
    }
}
