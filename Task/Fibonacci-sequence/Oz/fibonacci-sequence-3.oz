fun{Fib N}
   fun{Loop N A B}
      if N == 0 then
	 B
      else
	 {Loop N-1 A+B A}
      end
   end
in
   {Loop N 1 0}
end
