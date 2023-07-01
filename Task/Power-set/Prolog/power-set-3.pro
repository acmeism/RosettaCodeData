:- use_module(library(chr)).

:- chr_constraint chr_power_set/2, chr_power_set/1, clean/0.

clean @ clean \ chr_power_set(_) <=> true.
clean @ clean <=> true.

only_one @ chr_power_set(A) \ chr_power_set(A) <=> true.


creation @ chr_power_set([H | T], A) <=>
           append(A, [H], B),
	   chr_power_set(T, A),
           chr_power_set(T, B),
	   chr_power_set(B).


empty_element @ chr_power_set([], _) <=> chr_power_set([]).
