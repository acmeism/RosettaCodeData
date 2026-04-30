void proc() {
  print(" Inside loop");
}

void repeat(Function func, int times) {
  for (var i = 0; i < times; i++) {
    func();
  }
}

void main() {
  repeat(proc, 5);
  print("Loop Ended");
}
