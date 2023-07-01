new File("Test.txt").eachLine { line, lineNumber ->
    println "processing line $lineNumber: $line"
}
