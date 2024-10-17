import java.nio.charset.StandardCharsets
import java.nio.file.Files
import java.nio.file.Paths

data class Configuration(val map: Map<String, Any?>) {
    val fullName: String by map
    val favoriteFruit: String by map
    val needsPeeling: Boolean by map
    val otherFamily: List<String> by map
}

fun main(args: Array<String>) {
    val lines = Files.readAllLines(Paths.get("src/configuration.txt"), StandardCharsets.UTF_8)
    val keyValuePairs = lines.map{ it.trim() }
            .filterNot { it.isEmpty() }
            .filterNot(::commentedOut)
            .map(::toKeyValuePair)

    val configurationMap = hashMapOf<String, Any>("needsPeeling" to false)
    for (pair in keyValuePairs) {
        val (key, value) = pair
        when (key) {
            "FULLNAME"       -> configurationMap.put("fullName", value)
            "FAVOURITEFRUIT" -> configurationMap.put("favoriteFruit", value)
            "NEEDSPEELING"   -> configurationMap.put("needsPeeling", true)
            "OTHERFAMILY"    -> configurationMap.put("otherFamily", value.split(" , ").map { it.trim() })
            else             -> println("Encountered unexpected key $key=$value")
        }
    }
    println(Configuration(configurationMap))
}

private fun commentedOut(line: String) = line.startsWith("#") || line.startsWith(";")

private fun toKeyValuePair(line: String) = line.split(Regex(" "), 2).let {
    Pair(it[0], if (it.size == 1) "" else it[1])
}
