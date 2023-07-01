boolean[] doors = new boolean[100];

void setup() {
  for (int i = 0; i < 100; i++) {
    doors[i] = false;
  }
  for (int i = 1; i < 100; i++) {
    for (int j = 0; j < 100; j += i) {
      doors[j] = !doors[j];
    }
  }
  println("Open:");
  for (int i = 1; i < 100; i++) {
    if (doors[i]) {
      println(i);
    }
  }
  exit();
}
