void main() async {
  Future<void> sleepsort(Iterable<int> input) => Future.wait(input
      .map((i) => Future.delayed(Duration(milliseconds: i), () => print(i))));

  await sleepsort([3, 10, 2, 120, 122, 121, 54]);
}
