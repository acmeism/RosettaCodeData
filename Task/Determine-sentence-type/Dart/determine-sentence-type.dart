void main() {
  List<String> spam = [
    "hi there, how are you today?",
    "I'd like to present to you the washing machine 9001.",
    "You have been nominated to win one of these!",
    "Just make sure you don't break it"
  ];

  for (var s in spam) {
    print('$s -> ${sentenceType(s)}');
  }
}

String sentenceType(String s) {
  String lastChar = s[s.length - 1];
  if (lastChar == '?') return 'Q';
  if (lastChar == '!') return 'E';
  if (lastChar == '.') return 'S';
  return 'N';
}
