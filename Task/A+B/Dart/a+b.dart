import 'dart:io';
import 'dart:convert';

bool isAnInteger(String str) => str.contains(new RegExp(r'^-?\d+$'));

void main() {
  stdin.transform(new AsciiDecoder())
    .transform(new LineSplitter())
    .listen((String str) {
      var strings = str.split(new RegExp(r'[ ]+')); // split on 1 or more spaces
      if(!strings.every(isAnInteger)) {
        print("not an integer!");
      } else if(strings.length > 2) {
        print("too many numbers!");
      } else if(strings.length < 2) {
        print('not enough numbers!');
      } else {
        // parse the strings into integers
        var nums = strings.map((String s) => int.parse(s));
        if(nums.any((num) => num < -1000 || num > 1000)) {
          print("between -1000 and 1000 please!");
        } else {
          print(nums[0]+ nums[1]);
        }
      }
    });
}
