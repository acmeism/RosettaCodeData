int contarJoyas(String piedras, String joyas) {
  int cnt = 0;
  for (int i = 0; i < piedras.length; i++) {
    if (joyas.contains(piedras[i])) {
      cnt++;
    }
  }
  return cnt;
}

void main() {
  print(contarJoyas("aAAbbbb", "aA"));
  print(contarJoyas("ZZ", "z"));
  print(contarJoyas("ABCDEFGHIJKLMNOPQRSTUVWXYZ@abcdefghijklmnopqrstuvwxyz",
      "ABCDEFGHIJKLMNOPQRSTUVWXYZ@abcdefghijklmnopqrstuvwxyz"));
  print(contarJoyas("AB", ""));
}
