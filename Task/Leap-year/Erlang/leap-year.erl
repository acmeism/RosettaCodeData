-module(gregorian).
-export([leap/1]).

leap(Year) when Year rem   4 /= 0 -> false;
leap(Year) when Year rem 100 /= 0 -> true;
leap(Year) when Year rem 400 == 0 -> true;
leap(_) -> false.
