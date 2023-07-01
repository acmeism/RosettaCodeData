import 'dart:io' show Directory, Platform, File;

void main(List<String> args) {
  var dir = Directory(args[0]);
  dir.list(recursive: true, followLinks: false).forEach((final cur) {
    if (cur is Directory) {
      print("Directory: ${cur.path}");
    }

    if (cur is File) {
      print("File: ${cur.path}");
    }
  });
}
