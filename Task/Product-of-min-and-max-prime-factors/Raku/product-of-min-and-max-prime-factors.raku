use Prime::Factor;
put "Product of smallest and greatest prime factors of n for 1 to 100:\n" ~
  (1..100).map({ 1 max .max × .min given cache .&prime-factors })».fmt("%4d").batch(10).join: "\n";
