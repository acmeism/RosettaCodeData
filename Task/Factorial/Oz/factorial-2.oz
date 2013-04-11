fun {Fac2 N}
   fun {Loop N Acc}
      if N < 1 then Acc
      else
	 {Loop N-1 N*Acc}
      end
   end
in
   {Loop N 1}
end
