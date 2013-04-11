class Circle (x, y, r)
  # make a new copy of this instance
  method copy ()
    return Circle (x, y, r)
  end

  # print a representation of this instance
  method print ()
    write ("Circle (" || x || ", " || y || ", " || r || ")")
  end

  # called during instance construction, to pass in field values
  initially (x, y, r)
    self.x := if /x then 0 else x # set to 0 if argument not present
    self.y := if /y then 0 else y
    self.r := if /r then 0 else r

end

class Point (x, y)
  # make a new copy of this instance
  method copy ()
    return Point (x, y)
  end

  # print a representation of this instance
  method print ()
    write ("Point (" || x || ", " || y || ")")
  end

  # called during instance construction, to pass in field values
  initially (x, y)
    self.x := if /x then 0 else x # set to 0 if argument not present
    self.y := if /y then 0 else y

end

procedure main ()
  p1 := Point ()
  p2 := Point (1)
  p3 := Point (1,2)
  p4 := p3.copy ()

  write ("Points:")
  p1.print ()
  p2.print ()
  p3.print ()
  p4.print ()
  # demonstrate field mutator/accessor
  p3.x := 3
  write ("p3 value of x is: " || p3.x)

  c1 := Circle ()
  c2 := Circle (1)
  c3 := Circle (1,2)
  c4 := Circle (1,2,3)

  write ("Circles:")
  c1.print ()
  c2.print ()
  c3.print ()
  c4.print ()
end
