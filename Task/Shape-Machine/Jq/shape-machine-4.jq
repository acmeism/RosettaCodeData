{a: input}
| until(.aprime == .a;
  .i += 1
  | .aprime=.a
  | .a += 3 | .a  *= 0.86)
