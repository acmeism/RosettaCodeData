state(ready, deposit, waiting).
state(ready, quit, exit).
state(waiting, select, dispense).
state(waiting, refund, refunding).
state(dispense, remove, ready).

message(ready, 'Please deposit coins.~n').
message(waiting, 'Please select an item, or refund coins.~n').
message(dispense, 'Please remove your item.~n').
message(refunding, 'Coins have been refunded~n').

act :- act(ready).

act(exit).
act(refunding) :-
	print_message(refunding),
	act(ready).
act(State) :-
	dif(State, exit),
	print_message(State),
	read(Action),
	state(State, Action, NextState),
	act(NextState).
	
print_message(State) :-	message(State, Message), format(Message).
