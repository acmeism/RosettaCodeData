class Example (x) # 'x' is a field in class

  # method definition
  method double ()
    return 2 * x
  end

  # 'initially' block is called on instance construction
  initially (x)
    if /x # if x is null (not given), then set field to 0
      then self.x := 0
      else self.x := x
end

procedure main ()
  x1 := Example ()  # new instance with default value of x
  x2 := Example (2) # new instance with given value of x
  write (x1.x)
  write (x2.x)
  write (x2.double ()) # call a method
end
