declare
  local
     fun {Loop Xs Changed ?IsSorted}
        case Xs
        of X1|X2|Xr andthen X1 > X2 then
           X2|{Loop X1|Xr true IsSorted}
        [] X|Xr then
           X|{Loop Xr Changed IsSorted}
        [] nil then
           IsSorted = {Not Changed}
           nil
        end
     end
  in
     fun {BubbleSort Xs}
        IsSorted
        Result = {Loop Xs false ?IsSorted}
     in
        if IsSorted then Result
        else {BubbleSort Result}
        end
     end
  end
in
  {Show {BubbleSort [3 1 4 1 5 9 2 6 5]}}
