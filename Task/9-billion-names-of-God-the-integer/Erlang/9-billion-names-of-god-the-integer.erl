-module(triangle).
-export([start/1]).
start(N)->
  print(1,1,N).
print(N,N,N)->
1;
print(A,B,N) when A>=B->
   io:format("~p ",[formula(A,B)]),
   print(A,B+1,N);
print(A,B,N) when B>A->
   io:format("~n"),
   print(A+1,1,N).

formula(_,0)->
  0;
formula(B,B)->
  1;
formula(A,B) when B>A->
  0;
formula(A1,B1)->
  formula(A1-1,B1-1)+formula(A1-B1,B1).
