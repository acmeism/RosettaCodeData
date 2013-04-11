functor
export
   New
   Get
   Set
   Transform
define
   fun {New Width Height Init}
      C = {Array.new 1 Height unit}
   in
      for Row in 1..Height do
	 C.Row := {Array.new 1 Width Init}
      end

      array2d(width:Width
	      height:Height
	      contents:C)
   end

   fun {Get array2d(contents:C ...) X Y}
      C.Y.X
   end

   proc {Set array2d(contents:C ...) X Y Val}
      C.Y.X := Val
   end

   proc {Transform array2d(contents:C width:W height:H ...) Fun}
      for Y in 1..H do
	 for X in 1..W do
	    C.Y.X := {Fun C.Y.X}
	 end
      end
   end

   %% omitted: Clone, Map, Fold, ForAll
end
