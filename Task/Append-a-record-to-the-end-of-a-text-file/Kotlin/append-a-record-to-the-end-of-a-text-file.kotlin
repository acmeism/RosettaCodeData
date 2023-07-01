// Version 1.2.41

import java.io.File

class Record(
    val account: String,
    val password: String,
    val uid: Int,
    val gid: Int,
    val gecos: List<String>,
    val directory: String,
    val shell: String
){
    override fun toString() =
        "$account:$password:$uid:$gid:${gecos.joinToString(",")}:$directory:$shell"
}

fun parseRecord(line: String): Record {
    val fields = line.split(':')
    return Record(
        fields[0],
        fields[1],
        fields[2].toInt(),
        fields[3].toInt(),
        fields[4].split(','),
        fields[5],
        fields[6]
    )
}

fun main(args: Array<String>) {
    val startData = listOf(
        "jsmith:x:1001:1000:Joe Smith,Room 1007,(234)555-8917,(234)555-0077,[email protected]:/home/jsmith:/bin/bash",
        "jdoe:x:1002:1000:Jane Doe,Room 1004,(234)555-8914,(234)555-0044,[email protected]:/home/jdoe:/bin/bash"
    )
    val records = startData.map { parseRecord(it) }
    val f = File("passwd.csv")
    f.printWriter().use {
        for (record in records) it.println(record)
    }
    println("Initial records:\n")
    f.forEachLine {
        println(parseRecord(it))
    }

    val newData = "xyz:x:1003:1000:X Yz,Room 1003,(234)555-8913,(234)555-0033,[email protected]:/home/xyz:/bin/bash"
    val record = parseRecord(newData)
    if (!f.setWritable(true, true)) {
        println("\nFailed to make file writable only by owner\n.")
    }
    f.appendText("$record\n")
    println("\nRecords after another one is appended:\n")
    f.forEachLine {
        println(parseRecord(it))
    }
}
