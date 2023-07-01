shared void run() {

   while(true) {
      process.write("> ");
      String? text = process.readLine();
      if (is String text) {
      print(text.reversed);
      }
      else {
      break;
      }
    }
}
