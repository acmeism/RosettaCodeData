def i := makeImage(5, 20)
drawLine(i, 1, 1, 3, 18, makeColor.fromFloat(0,1,1))
i.writePPM(<import:java.io.makeFileOutputStream>(<file:~/Desktop/Bresenham.ppm>))
