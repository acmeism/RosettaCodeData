julia > function mycompare(a, b)::Cint
      (a < b) ? -1 : ((a > b) ? +1 : 0)
  end
mycompare (generic function with 1 method)
