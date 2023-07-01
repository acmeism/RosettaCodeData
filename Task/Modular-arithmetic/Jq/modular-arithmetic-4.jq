def main:
  (ring::f(1) | "f(\(1)) => \(.)"),
  (modint::make(10;13)
   | ring::f(.) as $out
    | "f(\(ring::pp)) => \($out|ring::pp)");
