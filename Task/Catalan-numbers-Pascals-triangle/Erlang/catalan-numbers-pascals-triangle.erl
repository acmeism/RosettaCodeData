-module(catalin).
-compile(export_all).
mul(N,D,S,S)->
	N2=N*(S+S),
	D2=D*S,
	K = N2 div D2 ;
mul(N,D,S,L)->
	N2=N*(S+L),
	D2=D*L,
	K = mul(N2,D2,S,L+1).
	
catl(Ans,16) -> Ans;
catl(D,S)->
	C=mul(1,1,S,2),
	catl([D|C],S+1).
main()->
	Ans=catl(1,2).
