function foo () {
  var stack = "Stack trace:";
  for (var f = arguments.callee // current function
       ; f; f = f.caller) {
    stack += "\n" + f.name;
  }
  alert(stack);
}
foo();
