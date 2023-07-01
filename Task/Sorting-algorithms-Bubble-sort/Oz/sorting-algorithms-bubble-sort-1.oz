declare
  proc {BubbleSort Arr}
     proc {Swap I J}
        Arr.J := (Arr.I := Arr.J) %% assignment returns the old value
     end
     IsSorted = {NewCell false}
     MaxItem = {NewCell {Array.high Arr}-1}
  in
     for until:@IsSorted do
        IsSorted := true
        for I in {Array.low Arr}..@MaxItem do
           if Arr.I > Arr.(I+1) then
              IsSorted := false
              {Swap I I+1}
           end
        end
        MaxItem := @MaxItem - 1
     end
  end
  Arr = {Tuple.toArray unit(10 9 8 7 6 5 4 3 2 1)}
in
  {BubbleSort Arr}
  {Inspect Arr}
