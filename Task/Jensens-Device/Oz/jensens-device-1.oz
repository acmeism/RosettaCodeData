declare
  fun {Sum I Lo Hi Term}
     Temp = {NewCell 0.0}
  in
     I := Lo
     for while:@I =< Hi do
        Temp := @Temp + {Term}
        I := @I + 1
     end
     @Temp
  end
  I = {NewCell unit}
in
  {Show {Sum I 1 100 fun {$} 1.0 / {Int.toFloat @I} end}}
