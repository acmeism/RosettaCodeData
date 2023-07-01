  proc {SwapCells A B}
     Tmp = @A
  in
     A := @B
     B := Tmp
  end
