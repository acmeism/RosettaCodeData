-module(daysbetween).
-export([between/2,dateToInts/2]).

% Return Year or Month or Date from datestring
dateToInts(String, POS) ->
  list_to_integer( lists:nth( POS, string:tokens(String, "-") ) ).

% Alternative form of above
% dateToInts(String,POS) ->
%   list_to_integer( lists:nth( POS, re:split(String ,"-", [{return,list},trim]) ) ).

% Return the number of days between dates formatted "2019-09-30"
between(DateOne,DateTwo) ->
  L = [1,2,3],
  [Y1,M1,D1] =  [ dateToInts(DateOne,X) || X <- L],
  [Y2,M2,D2] =  [ dateToInts(DateTwo,X) || X <- L],
  GregOne = calendar:date_to_gregorian_days(Y1,M1,D1),
  GregTwo = calendar:date_to_gregorian_days(Y2,M2,D2),
  GregTwo - GregOne.


