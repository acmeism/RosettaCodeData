// Version 1.2.41

fun main(args:Array<String>) {
    val synthType = "sine"
    val duration = "5"
    val frequency = "440"
    val pb = ProcessBuilder("play", "-n", "synth", duration, synthType, frequency)
    pb.directory(null)
    val proc = pb.start()
    proc.waitFor()
}
