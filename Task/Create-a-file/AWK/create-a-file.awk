BEGIN {
  printf "" > "output.txt"
  close("output.txt")
  printf "" > "/output.txt"
  close("/output.txt")
  system("mkdir docs")
  system("mkdir /docs")
}
