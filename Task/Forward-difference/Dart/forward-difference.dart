List forwardDifference(List _list) {
  for (int i = _list.length - 1; i > 0; i--) {
    _list[i] = _list[i] - _list[i - 1];
  }

  _list.removeRange(0, 1);
  return _list;
}

void mainAlgorithms() {
  List _intList = [90, 47, 58, 29, 22, 32, 55, 5, 55, 73];

  for (int i = _intList.length - 1; i >= 0; i--) {
    List _list = forwardDifference(_intList);
    print(_list);
  }
}
