evens(D, Es) :- findall(E, (member(E, D), E mod 2 =:= 0), Es).
