function repeat(f, n) {
  while (n-- > 0) {
    f();
  }
}

function test() {
  console.log("test");
}

repeat(test, 3);
