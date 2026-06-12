import 'dart:math';

int sigmaSum(int n) {
  int sum = 0;

  for (int i = 1; i <= sqrt(n); i++) {
    if (n % i == 0) {
      sum += i;
      if (i != n ~/ i) {
        sum += n ~/ i;
      }
    }
  }

  return sum;
}

String formatWithCommas(int n) {
  String numStr = n.toString();
  String result = '';

  int len = numStr.length;
  int commaPos = ((len - 1) % 3) + 1;

  for (int i = 0; i < len; i++) {
    result += numStr[i];
    if (i == commaPos - 1 && i < len - 1) {
      result += ',';
      commaPos += 3;
    }
  }

  return result;
}

void main() {
  int count = 0;
  int num = 0;

  while (count < 50) {
    int sigmaOfNum = sigmaSum(num);
    int sigmaOfNextNum = sigmaSum(num + 1);

    if (sigmaOfNum == sigmaOfNextNum) {
      count++;
      String formattedNum = formatWithCommas(num);

      print('$count: $formattedNum');
    }

    num++;
  }
}
