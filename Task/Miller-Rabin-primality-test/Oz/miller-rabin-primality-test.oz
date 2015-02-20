%--------------------------------------------------------------------------%
% module: Primality
% file: Primality.oz
% version: 17 DEC 2014 @ 6:50AM
%--------------------------------------------------------------------------%

declare
%--------------------------------------------------------------------------%

fun {IsPrime N}			% main interface of module
	if N < 2 then false
	elseif N < 4 then true
	elseif (N mod 2) == 0 then false
	elseif N < 341330071728321 then {IsMRprime N {DetWit N}}
	else {IsMRprime N {ProbWit N 20}}
	end
end
%--------------------------------------------------------------------------%

fun {DetWit N}			% deterministic witnesses
	if N < 1373653 then [2 3]
	elseif N < 9080191 then [31 73]
	elseif N < 25326001 then [2 3 5]
	elseif N < 3215031751 then [2 3 5 7]
	elseif N < 4759123141 then [2 7 61]
	elseif N < 1122004669633 then [2 13 23 1662803]
	elseif N < 2152302898747 then [2 3 5 7 11]
	elseif N < 3474749660383 then [2 3 5 7 11 13]
	elseif N < 341550071728321 then [2 3 5 7 11 13 17]
	else nil
	end
end
%--------------------------------------------------------------------------%

fun {ProbWit N K}		% probabilistic witnesses
	local A B C in
	A = 6364136223846793005
	B = 1442695040888963407
	C = N - 2
	{RWloop N A B C K nil}
	end
end

fun {RWloop N A B C K L}
	local N1 in
		N1 = (((N * A) + B) mod C) + 1
		if K == 0 then L
		else {RWloop N1 A B C (K - 1) N1|L}
		end
	end
end
%--------------------------------------------------------------------------%

fun {IsMRprime N As}	% the Miller-Rabin algorithm	
	local D S T Ts in
	{FindDS N} = D|S
	{OuterLoop N As D S}
	end
end

fun {OuterLoop N As D S}
	local A At Base C in
	As = A|At
	Base = {Powm A D N}
	C = {InnerLoop Base N 0 S}
	if {Not C} then false
	elseif {And C (At == nil)} then true
	else {OuterLoop N At D S}
	end
	end
end
							
fun {InnerLoop Base N Loop S}
	local NextBase NextLoop in
	NextBase = (Base * Base) mod N
	NextLoop = Loop + 1
	   if {And (Loop == 0) (Base == 1)} then true
	   elseif Base == (N - 1) then true
	   elseif NextLoop == S then false
	   else {InnerLoop NextBase N NextLoop S}
	   end
	end
end
%--------------------------------------------------------------------------%

fun {FindDS N}
	{FindDS1 (N - 1) 0}
end

fun {FindDS1 D S}
	if (D mod 2 == 0) then {FindDS1 (D div 2) (S + 1)}
	else D|S
	end
end
%--------------------------------------------------------------------------%
	
fun {Powm A D N} 		% returns (A ^ D) mod N
	if D == 0 then 1
	elseif (D mod 2) == 0 then {Pow {Powm A (D div 2) N} 2} mod N
	else (A * {Powm A (D - 1) N}) mod N
	end
end
%--------------------------------------------------------------------------%	
% end_module Primality
