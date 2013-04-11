declare
  proc {Enumeration Xs}
     Xs = {List.number 1 {Length Xs} 1}
  end

  [Apple Banana Cherry] = {Enumeration}
in
  {Show Cherry}
