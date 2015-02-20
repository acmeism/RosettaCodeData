import 'dart:async';

Future<List<int>> sleepsort(List<int> input) {
  List<Future<int>> tasks = [];
  List<int> result = [];
  for (int i in input) {
    tasks.add(new Future.delayed(new Duration(seconds: i), () {
      result.add(i);
    }));
  }
  return Future.wait(tasks).then((_) {
    return result;
  });
}

sleepsort.sleepsort([3, 1, 2]).then((List<int> sorted) {
  print(sorted);
});
