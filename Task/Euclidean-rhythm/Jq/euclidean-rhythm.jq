def E(k; n):
  def list($value): [range(0,.) | $value];
  {s: ((k|list([1])) + ((n-k)|list([0]))),
   d: (n - k) }
  | .n = ([k, .d]|max)
  | .k = ([k, .d]|min)
  | .z = .d
  | until (.z <= 0 and .k <= 1;
      reduce range(0; .k) as $i (.; .s[$i] += .s[-1 - $i])
      | .s = .s[0: -.k]
      | .z -= .k
      | .d = .n - .k
      | .n = ([.k, .d] | max)
      | .k = ([.k, .d] | min)  )
   | .s
   | [.[][]]
   | join("");

E(5; 13)
