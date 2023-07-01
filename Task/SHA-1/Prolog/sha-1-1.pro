:- use_module(library(sha)).
sha_hex(Str,Hex):-
   sha_hash(Str, Hash, []),
   hash_atom(Hash, Hex).
