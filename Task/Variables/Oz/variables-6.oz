fun {Function Arg}
   LocalVar1
in
   LocalVar1 = if Arg == 42 then
		  LocalVar2
	       in
		  LocalVar2 = yes
		  LocalVar2
	       else
		  LocalVar3 = no  %% variables can be initialized when declared
	       in
		  LocalVar3
	       end
   LocalVar1
end
