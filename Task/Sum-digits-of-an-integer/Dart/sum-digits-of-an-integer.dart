import 'dart:math';

num sumDigits(var number, var nBase) {
  if (number < 0) number = -number; // convert negative numbers to positive
  if (nBase < 2) nBase = 2;         // nBase can't be less than 2
  num sum = 0;
  while (number > 0) {
    sum += number % nBase;
    number ~/= nBase;
  }
  return sum;
}

void main() {
  print('The sums of the digits are:\n');
  print('1    base 10 : ${sumDigits(1, 10)}');
  print('1234 base 10 : ${sumDigits(1234, 10)}');
  print('fe   base 16 : ${sumDigits(0xfe, 16)}');
  print('f0e  base 16 : ${sumDigits(0xf0e, 16)}');
}
