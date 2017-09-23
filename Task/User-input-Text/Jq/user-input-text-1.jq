def read(int):
  null | until( . == int;  "Expecting \(int)" | stderr | input);

def read_string:
  null | until( type == "string";  "Please enter a string" | stderr | input);

(read_string | "I see the string: \(.)"),
(read(75000) | "I see the expected integer: \(.)")
