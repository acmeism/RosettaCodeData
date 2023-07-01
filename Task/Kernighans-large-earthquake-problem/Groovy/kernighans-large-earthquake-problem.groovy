import java.util.regex.Pattern

class LargeEarthquake {
    static void main(String[] args) {
        def r = Pattern.compile("\\s+")
        println("Those earthquakes with a magnitude > 6.0 are:\n")
        def f = new File("data.txt")
        f.eachLine { it ->
            if (r.split(it)[2].toDouble() > 6.0) {
                println(it)
            }
        }
    }
}
