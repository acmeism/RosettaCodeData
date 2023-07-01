def readPPMTask(inputFile, outputFile) {
  makeGrayscale \
    .fromColor(readPPM(<import:java.io.makeFileInputStream>(inputFile))) \
    .toColor() \
    .writePPM(<import:java.io.makeFileOutputStream>(outputFile))
}
