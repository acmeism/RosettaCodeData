   fun {Prime N}
      local IPrime in
	 fun {IPrime N Acc}
	    if N < Acc*Acc then true
	    elseif (N mod Acc) == 0 then false
	    else {IPrime N Acc+1}
	    end
	 end
	 if N < 2 then false
	 else {IPrime N 2} end
      end
   end
