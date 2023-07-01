declare
  fun lazy {FiboSeq}
     {LazyMap
      {Iterate fun {$ [A B]} [B A+B] end [0 1]}
      Head}
  end

  fun {Head A|_} A end

  fun lazy {Iterate F I}
     I|{Iterate F {F I}}
  end

  fun lazy {LazyMap Xs F}
     case Xs of X|Xr then {F X}|{LazyMap Xr F}
     [] nil then nil
     end
  end
in
  {Show {List.take {FiboSeq} 8}}
