void main() {
  String word = "Premier League";
  print("Without first letter: ${word.substring(1)} !");
  print("Without last letter: ${word.substring(0, word.length - 1)} !");
  print("Without first and last letter: ${word.substring(1, word.length - 1)} !");
}
