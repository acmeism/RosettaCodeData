def examples:
  def pi: 1 | atan * 4;

  [1,1] as $v
  | [3,4] as $w
  | polar(1; pi/2) as $z
  | polar(-2; pi/4) as $z2
  | "v     is \($v)",
    "    w is \($w)",
    "v + w is \([$v, $w] | sum)",
    "v - w is \( $v |minus($w))",
    "  - v is \( $v|negate )",
    "w * 5 is \($w | multiply(5))",
    "w / 2 is \($w | divide(2))",
    "v|topolar is \($v|topolar)",
    "w|topolar is \($w|topolar)",
    "z = polar(1; pi/2) is \($z)",
    "z|topolar is \($z|topolar)",
    "z2 = polar(-2; pi/4) is \($z2)",
    "z2|topolar is \($z2|topolar)",
    "z2|topolar|polar is \($z2|topolar|polar2vector)" ;

examples
