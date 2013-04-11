BEGIN {
  s = "Hello,How,Are,You,Today"
  split(s, arr, ",")
  for(i=1; i < length(arr); i++) {
    printf arr[i] "."
  }
  print
}
