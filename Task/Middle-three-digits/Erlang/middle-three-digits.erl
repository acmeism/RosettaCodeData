% Implemented by Arjun Sunel
-module(middle_three_digits).
-export([main/0]).

main() ->
	digits(123),
	digits(12345),
	digits(1234567),
	digits(987654321),	
	digits(10001),
	digits(-10001),
	digits(-123),	
	digits(-100),
	digits(100),
	digits(-12345),
	digits(1),
	digits(2),
	digits(-1),
	digits(-10),
	digits(2002),
	digits(-2002),
	digits(0).

digits(N) ->

	if N < 0 ->
		digits(-N);

	(N div 100) =:= 0  ->
		io:format("too small\n");
	
	true ->
			K=length(integer_to_list(N)),
			
			if (K rem 2) =:= 0 ->
				 io:format("even number of digits\n");
			true ->	
				loop((K-3) div 2 , N)
			end
			
	end.		

loop(0,N)  ->
	if
		N rem 1000 =:= 0 ->
			io:format("000\n");
			
		N rem 1000 < 10 ->
			io:format("00~w~n",[N rem 1000]);	
						
		N rem 1000 < 100  ->
			io:format("0~w~n",[N rem 1000]);	
		true ->		
			io:format("~w~n", [N rem 1000])
	end;
	
loop(X,N)  when X>0 ->
	loop(X-1, N div 10).
