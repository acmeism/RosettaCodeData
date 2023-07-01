main() {
  String say(String from, String to) => "$from ---> $to";

  hanoi(int height, int toPole, int fromPole, int usePole) {
    if (height > 0) {
      hanoi(height - 1, usePole, fromPole, toPole);
      print(say(fromPole.toString(), toPole.toString()));
      hanoi(height - 1, toPole, usePole, fromPole);
    }
  }

  hanoi(3, 3, 1, 2);
}
