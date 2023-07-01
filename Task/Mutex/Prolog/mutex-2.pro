synchronized_goal(G) :- with_mutex(my_mutex, call(G)).
