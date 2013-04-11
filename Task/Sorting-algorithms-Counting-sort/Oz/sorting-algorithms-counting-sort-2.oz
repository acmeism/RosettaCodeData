declare
  fun {CountingSort Xs}
     Count = {Dictionary.new}
  in
     for X in Xs do
        Count.X := {CondSelect Count X 0} + 1
     end
     {Concat {Map {Dictionary.entries Count} Repeat}}
  end

  fun {Repeat Val#Count}
     if Count == 0 then nil
     else Val|{Repeat Val#Count-1}
     end
  end

  fun {Concat Xs}
     {FoldR Xs Append nil}
  end
in
  {Show {CountingSort [3 1 4 1 5 9 2 6 5]}}
