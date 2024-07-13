begin
  Println(1.0/real.PositiveInfinity); // 0
  Println(1.0/real.NegativeInfinity); // 0
  Println(0.0/0.0);  // NaN
  Println(1.0/0.0);  // Infinity
  Println(-1.0/0.0); // -Infinity
  Println(real.NegativeInfinity < real.PositiveInfinity); // True
  Println(real.NegativeInfinity + real.PositiveInfinity); // NaN
  Println(real.PositiveInfinity + real.PositiveInfinity); // Infinity
  Println(real.PositiveInfinity / real.PositiveInfinity); // NaN
  Println(Sqrt(-1)); // NaN
  Println(real.NaN = real.NaN); // False
  Println(real.IsNaN(Sqrt(-1))); // True
end.
