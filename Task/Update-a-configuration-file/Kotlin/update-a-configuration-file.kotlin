// version 1.2.0

import java.io.File

class ConfigData(
    val favouriteFruit: String,
    val needsPeeling: Boolean,
    val seedsRemoved: Boolean,
    val numberOfBananas: Int,
    val numberOfStrawberries: Int
)

fun updateConfigFile(fileName: String, cData: ConfigData) {
    val inp = File(fileName)
    val lines = inp.readLines()
    val tempFileName = "temp_$fileName"
    val out = File(tempFileName)
    val pw = out.printWriter()
    var hadFruit = false
    var hadPeeling = false
    var hadSeeds = false
    var hadBananas = false
    var hadStrawberries = false

    for (line in lines) {
        if (line.isEmpty() || line[0] == '#') {
            pw.println(line)
            continue
        }
        val ln = line.trimStart(';').trim(' ', '\t').toUpperCase()
        if (ln.isEmpty()) continue
        if (ln.take(14) == "FAVOURITEFRUIT") {
            if (hadFruit) continue
            hadFruit = true
            pw.println("FAVOURITEFRUIT ${cData.favouriteFruit}")
        }
        else if (ln.take(12) == "NEEDSPEELING") {
            if (hadPeeling) continue
            hadPeeling = true
            if (cData.needsPeeling)
                pw.println("NEEDSPEELING")
            else
                pw.println("; NEEDSPEELING")
        }
        else if (ln.take(12) == "SEEDSREMOVED") {
            if (hadSeeds) continue
            hadSeeds = true
            if (cData.seedsRemoved)
                pw.println("SEEDSREMOVED")
            else
                pw.println("; SEEDSREMOVED")
        }
        else if(ln.take(15) == "NUMBEROFBANANAS") {
            if (hadBananas) continue
            hadBananas = true
            pw.println("NUMBEROFBANANAS ${cData.numberOfBananas}")
        }
        else if(ln.take(20) == "NUMBEROFSTRAWBERRIES") {
            if (hadStrawberries) continue
            hadStrawberries = true
            pw.println("NUMBEROFSTRAWBERRIES ${cData.numberOfStrawberries}")
        }
    }

    if (!hadFruit) {
        pw.println("FAVOURITEFRUIT ${cData.favouriteFruit}")
    }

    if (!hadPeeling) {
        if (cData.needsPeeling)
            pw.println("NEEDSPEELING")
        else
            pw.println("; NEEDSPEELING")
    }

    if (!hadSeeds) {
        if (cData.seedsRemoved)
            pw.println("SEEDSREMOVED")
        else
            pw.println("; SEEDSREMOVED")
    }

    if (!hadBananas) {
       pw.println("NUMBEROFBANANAS ${cData.numberOfBananas}")
    }

    if (!hadStrawberries) {
       pw.println("NUMBEROFSTRAWBERRIES ${cData.numberOfStrawberries}")
    }

    pw.close()
    inp.delete()
    out.renameTo(inp)
}

fun main(args: Array<String>) {
    val fileName = "config.txt"
    val cData = ConfigData("banana", false, true, 1024, 62000)
    updateConfigFile(fileName, cData)
}
