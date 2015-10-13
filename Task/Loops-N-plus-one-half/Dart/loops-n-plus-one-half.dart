String loopPlusHalf(start, end) {
  var result = '';
  for(int i = start; i <= end; i++) {
    result += '$i';
    if(i == end) {
      break;
    }
    result += ', ';
  }
  return result;
}

void main() {
  print(loopPlusHalf(1, 10));
}
