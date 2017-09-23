main() {
  for (int i = 1; i <= 100; i++) {
    List<String> out = [];
    if (i % 3 == 0)
      out.add("Fizz");
    if (i % 5 == 0)
      out.add("Buzz");
    print(out.length > 0 ? out.join("") : i);
  }
}
