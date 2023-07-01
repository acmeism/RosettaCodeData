-module(vector).
-export([main/0]).
vector_product(X,Y)->
[X1,X2,X3]=X,
[Y1,Y2,Y3]=Y,
Ans=[X2*Y3-X3*Y2,X3*Y1-X1*Y3,X1*Y2-X2*Y1],
Ans.
dot_product(X,Y)->
[X1,X2,X3]=X,
[Y1,Y2,Y3]=Y,
Ans=X1*Y1+X2*Y2+X3*Y3,
io:fwrite("~p~n",[Ans]).
main()->
{ok, A} = io:fread("Enter vector A : ", "~d ~d ~d"),
{ok, B} = io:fread("Enter vector B : ", "~d ~d ~d"),
{ok, C} = io:fread("Enter vector C : ", "~d ~d ~d"),
dot_product(A,B),
Ans=vector_product(A,B),
io:fwrite("~p,~p,~p~n",Ans),
dot_product(C,vector_product(A,B)),
io:fwrite("~p,~p,~p~n",vector_product(C,vector_product(A,B))).
