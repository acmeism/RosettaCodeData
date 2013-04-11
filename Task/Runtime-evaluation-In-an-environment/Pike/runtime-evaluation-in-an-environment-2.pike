string payload = "x * 5";

program demo = compile_string("string eval(mixed x){ " + payload + "; }");

demo()->eval(10);
Result: 50
demo()->eval(20);
Result: 100
