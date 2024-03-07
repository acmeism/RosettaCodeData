void main() {
  List<int> array = List.generate(4, (i) => i);
  HeapsAlgorithm algorithm = HeapsAlgorithm();
  algorithm.recursive(array);
  print('');
  algorithm.loop(array);
}

class HeapsAlgorithm {
  void recursive(List array) {
    _recursive(array, array.length, true);
  }

  void _recursive(List array, int n, bool plus) {
    if (n == 1) {
      _output(array, plus);
    } else {
      for (int i = 0; i < n; i++) {
        _recursive(array, n - 1, i == 0);
        _swap(array, n % 2 == 0 ? i : 0, n - 1);
      }
    }
  }

  void _output(List array, bool plus) {
    print(array.toString() + (plus ? ' +1' : ' -1'));
  }

  void _swap(List array, int a, int b) {
    var temp = array[a];
    array[a] = array[b];
    array[b] = temp;
  }

  void loop(List array) {
    _loop(array, array.length);
  }

  void _loop(List array, int n) {
    List<int> c = List.filled(n, 0);
    _output(array, true);
    bool plus = false;
    int i = 0;
    while (i < n) {
      if (c[i] < i) {
        if (i % 2 == 0) {
          _swap(array, 0, i);
        } else {
          _swap(array, c[i], i);
        }
        _output(array, plus);
        plus = !plus;
        c[i]++;
        i = 0;
      } else {
        c[i] = 0;
        i++;
      }
    }
  }
}
