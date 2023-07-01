declare
  proc {CountingSort Arr Min Max}
     Count = {Array.new Min Max 0}
     Z = {NewCell {Array.low Arr}}
  in
     %% fill frequency array
     for J in {Array.low Arr}..{Array.high Arr} do
        Number = Arr.J
     in
        Count.Number := Count.Number + 1
     end
     %% recreate array from frequencies
     for I in Min..Max do
        for C in 1..Count.I do
  	 Arr.(@Z) := I
  	 Z := @Z + 1
        end
     end
  end

  A = {Tuple.toArray unit(3 1 4 1 5 9 2 6 5)}
in
  {CountingSort A 1 9}
  {Show {Array.toRecord unit A}}
