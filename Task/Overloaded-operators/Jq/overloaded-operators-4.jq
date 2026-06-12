def foo:
  def outer_length: length;
  def length: outer_length | tostring;
  [outer_length, length];

"x" | foo #=> [1, "1"]
