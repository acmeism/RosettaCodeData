def demo:
  "lstrip: \(lstrip)",
  "rstrip: \(rstrip)",
  "strip: \(strip)" ;

(" \t \r \n String with spaces \t  \r  \n  ",
 "� <- control A",
 "\u0001 \u0002 <- ^A ^B"
)  | demo
