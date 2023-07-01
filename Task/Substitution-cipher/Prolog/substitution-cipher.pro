cypher(O, S) :-
	nonvar(O),
	var(S),
	atom_chars(O,Oc),
	sub_chars(Oc,Sc),
	atom_chars(S,Sc).
cypher(O, S) :-
	nonvar(S),
	var(O),
	atom_chars(S,Sc),
	sub_chars(Oc,Sc),
	atom_chars(O,Oc).	
	
% mapping based on ADA implementation but have added space character	
base(['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z',a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,' ']).
subs(['V',s,c,i,'B',j,e,d,g,r,z,y,'H',a,l,v,'X','Z','K',t,'U','P',u,m,'G',f,'I',w,'J',x,q,'O','C','F','R','A',p,n,'D',h,'Q','W',o,b,' ','L',k,'E','S','Y','M','T','N']).

sub_chars(Original,Subbed) :-
	base(Base),
	subs(Subs),
	maplist(sub_char(Base,Subs),Original,Subbed).	
	
sub_char([Co|_],[Cs|_],Co,Cs) :- !.
sub_char([_|To],[_|Ts], Co, Cs) :- sub_char(To,Ts,Co,Cs).
