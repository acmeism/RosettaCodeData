var colors = [
    [255,   0,   0], // red
    [255, 128,   0], // orange
    [255, 255,   0], // yellow
    [  0, 255,   0], // green
    [  0,   0, 255], // blue
    [ 75,   0, 130], // indigo
    [128,   0, 255]  // violet
]

var s = "RAINBOW"
for (i in 0..6) {
    var fore = "\e[38;2;%(colors[i][0]);%(colors[i][1]);%(colors[i][2])m"
    System.write("%(fore)%(s[i])")
}
System.print()
