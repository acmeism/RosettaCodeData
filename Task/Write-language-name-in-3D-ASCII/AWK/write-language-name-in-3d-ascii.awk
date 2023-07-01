# syntax: GAWK -f WRITE_LANGUAGE_NAME_IN_3D_ASCII.AWK
BEGIN {
    arr[1] = " xxxx    x    x   x   x"
    arr[2] = "x    x   x    x   x  x"
    arr[3] = "x    x   x    x   x x"
    arr[4] = "xxxxxx   x    x   xx"
    arr[5] = "x    x   x xx x   xx"
    arr[6] = "x    x   xx  xx   x x"
    arr[7] = "x    x   xx  xx   x  x"
    arr[8] = "A    V   P    J   B   W"
    for (i=1; i<=8; i++) {
      x = arr[i]
      gsub(/./,"& ",x)
      gsub(/[xA-Z] /,"_/",x)
      print(x)
    }
    exit(0)
}
