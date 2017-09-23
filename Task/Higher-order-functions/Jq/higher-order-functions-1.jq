def foo( filter ):
  ("world" | filter) as $str
  | "hello \($str)" ;

# blue is defined here as a filter that adds blue to its input:
def blue: "blue \(.)";

foo( blue ) # prints "hello blue world"
