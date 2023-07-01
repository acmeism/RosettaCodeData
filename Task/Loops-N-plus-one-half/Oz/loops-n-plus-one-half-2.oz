declare
  fun {CommaSep Xs}
     case Xs of nil then nil
     [] X|Xr then
	{FoldL Xr
	 fun {$ Z X} Z#", "#X end
	 X}
     end
  end
in
  {System.showInfo {CommaSep {List.number 1 10 1}}}
