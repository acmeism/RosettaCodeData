-module(solution).
-import(lists,[delete/2,max/1]).
-compile(export_all).
selection_sort([],Sort)-> Sort;
selection_sort(Ar,Sort)->
	M=max(Ar),
	Ad=delete(M,Ar),
	selection_sort(Ad,[M|Sort]).
print_array([])->ok;
print_array([H|T])->
	io:format("~p~n",[H]),
	print_array(T).	

main()->
	Ans=selection_sort([1,5,7,8,4,10],[]),
	print_array(Ans).
