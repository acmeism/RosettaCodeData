fun printDebug(message: String) {
    val exception = RuntimeException()
    val stackTrace = exception.stackTrace
    val stackTraceElement = stackTrace[1]
    val fileName = stackTraceElement.fileName
    val className = stackTraceElement.className
    val methodName = stackTraceElement.methodName
    val lineNumber = stackTraceElement.lineNumber

    println("[DEBUG][$fileName $className.$methodName#$lineNumber] $message")
}

fun blah() {
    printDebug("Made It!")
}

fun main() {
    printDebug("Hello world.")
    blah()

    val oops = { printDebug("oops") }
    oops.invoke()

    fun nested() {
        printDebug("nested")
    }
    nested()
}
