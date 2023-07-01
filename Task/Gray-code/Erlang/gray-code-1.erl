-module(gray).
-export([encode/1, decode/1]).

encode(N) -> N bxor (N bsr 1).

decode(G) -> decode(G,0).

decode(0,N) -> N;
decode(G,N) -> decode(G bsr 1, G bxor N).
