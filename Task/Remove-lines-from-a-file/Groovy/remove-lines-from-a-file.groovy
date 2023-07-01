static def removeLines(String filename, int startingLine, int lineCount) {
    def sourceFile = new File(filename).getAbsoluteFile()
    def outputFile = File.createTempFile("remove", ".tmp", sourceFile.getParentFile())

    outputFile.withPrintWriter { outputWriter ->
        sourceFile.eachLine { line, lineNumber ->
            if (lineNumber < startingLine || lineNumber - startingLine >= lineCount)
                outputWriter.println(line)
        }
    }

    outputFile.renameTo(sourceFile)
}

removeLines(args[0], args[1] as Integer, args[2] as Integer)
