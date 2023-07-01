void main() {
  string s = "Hello,How,Are,You,Today";
  print(@"$(string.joinv(".", s.split(",")))");
}
