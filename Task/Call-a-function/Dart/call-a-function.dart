void main() {
  // Function definition
  // See the "Function definition" task for more info
  void noArgs() {}
  void fixedArgs(int arg1, int arg2) {}
  void optionalArgs([int arg1 = 1]) {}
  void namedArgs({required int arg1}) {}
  int returnsValue() {return 1;}

  // Calling a function that requires no arguments
  noArgs();

  // Calling a function with a fixed number of arguments
  fixedArgs(1, 2);

  // Calling a function with optional arguments
  optionalArgs();
  optionalArgs(2);

  // Calling a function with named arguments
  namedArgs(arg1: 1);

  // Using a function in statement context
  if (true) {
    noArgs();
  }

  // Obtaining the return value of a function
  var value = returnsValue();
}
