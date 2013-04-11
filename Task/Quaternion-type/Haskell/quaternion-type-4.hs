procedure main ()
  q := Quaternion (1,2,3,4)
  q1 := Quaternion (2,3,4,5)
  q2 := Quaternion (3,4,5,6)
  r := 7

  write ("The norm      of " || q.string() || " is " || q.norm ())
  write ("The negative  of " || q.string() || " is " || q.negative().string ())
  write ("The conjugate of " || q.string() || " is " || q.conjugate().string ())
  write ("Sum of " || q.string() || " and " || r || " is " || q.add(r).string ())
  write ("Sum of " || q.string() || " and " || q1.string() || " is " || q.add(q1).string ())
  write ("Product of " || q.string() || " and " || r || " is " || q.multiply(r).string ())
  write ("Product of " || q.string() || " and " || q1.string() || " is " || q.multiply(q1).string ())
  write ("q1*q2 = " || q1.multiply(q2).string ())
  write ("q2*q1 = " || q2.multiply(q1).string ())
end
