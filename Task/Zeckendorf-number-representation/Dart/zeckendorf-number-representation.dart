class Zeckendorf {
  static String getZeckendorf(int n) {
    if (n == 0) {
      return "0";
    }
    List<int> fibNumbers = [1];
    int nextFib = 2;
    while (nextFib <= n) {
      fibNumbers.add(nextFib);
      nextFib += fibNumbers[fibNumbers.length - 2];
    }
    StringBuffer sb = StringBuffer();
    for (int i = fibNumbers.length - 1; i >= 0; i--) {
      int fibNumber = fibNumbers[i];
      sb.write((fibNumber <= n) ? "1" : "0");
      if (fibNumber <= n) {
        n -= fibNumber;
      }
    }
    return sb.toString();
  }

  static void main() {
    for (int i = 0; i <= 20; i++) {
      print("Z($i)=${getZeckendorf(i)}");
    }
  }
}

void main() {
  Zeckendorf.main();
}
