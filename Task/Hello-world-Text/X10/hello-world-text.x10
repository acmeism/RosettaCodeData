class HelloWorld {
  public static def main(args:Rail[String]):void {
    if (args.size < 1) {
        Console.OUT.println("Hello world!");
        return;
    }
  }
}
