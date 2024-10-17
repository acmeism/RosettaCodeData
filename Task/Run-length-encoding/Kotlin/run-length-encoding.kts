tailrec fun runLengthEncoding(text:String,prev:String=""):String {
    if (text.isEmpty()){
        return prev
    }
    val initialChar = text.get(0)
    val count = text.takeWhile{ it==initialChar }.count()
    return runLengthEncoding(text.substring(count),prev + "$count$initialChar" )
}

fun main(args: Array<String>) {
    assert(runLengthEncoding("TTESSST") == "2T1E3S1T")
    assert(runLengthEncoding("WWWWWWWWWWWWBWWWWWWWWWWWWBBBWWWWWWWWWWWWWWWWWWWWWWWWBWWWWWWWWWWWWWW")
                   == "12W1B12W3B24W1B14W")
}
