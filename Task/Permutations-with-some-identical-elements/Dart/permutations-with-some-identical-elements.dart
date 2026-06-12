import 'dart:io';

void main() {
  stdout.writeln(distinctPerms([2,3,1]).map((p) => alpha("ABC", p)).toList());
}

String alpha(String alphabet, List<int> perm) {
  return perm.map((i) => alphabet[i]).join("");
}

Iterable<List<int>> distinctPerms(List<int> reps) sync* {
  Iterable<List<int>> perms(List<List<int>> elements) sync* {
    if (elements.length == 1) {
      yield List.of(elements[0]);
    } else {
      for (int k = 0; k < elements.length; k++) {
        List<List<int>> tail = [];
        for (int i = 0; i < elements.length; i++) {
          if (i == k) {
            if (elements[i].length > 1) {
              tail.add(List.of(elements[i].skip(1)));
            }
          } else {
            tail.add(elements[i]);
          }
        }
        yield* perms(tail).map((t) {
          t.insert(0, elements[k][0]);
          return t;
        });
      }
    }
  }
  List<List<int>> elements = [];
  for (int i = 0; i < reps.length; i++) {
    elements.add(List.filled(reps[i], i));
  }
  yield* perms(elements);
}
