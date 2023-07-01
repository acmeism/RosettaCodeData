def assert(value; f):
  value as $value
  | ($value|f) | if . then empty else error("assertion violation: \($value) => \(.)") end;

((2400, 2012, 2000, 1600, 1500, 1400) | assert(.; leap)),

((2100, 2014, 1900, 1800, 1700, 1499) | assert(.; leap|not))
