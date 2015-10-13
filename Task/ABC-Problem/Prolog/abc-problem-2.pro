:- use_module([ library(chr),
                abathslib(protelog/composer) ]).

:- chr_constraint blocks, block/1, letter/1, word_built.

can_build_word(Word) :-
    maplist(block, [(b,o),(x,k),(d,q),(c,p),(n,a),(g,t),(r,e),(t,g),(q,d),(f,s),
                    (j,w),(h,u),(v,i),(a,n),(o,b),(e,r),(f,s),(l,y),(p,c),(z,m)]),
    maplist(letter) <- string_chars <- string_lower(Word),     %% using the `composer` module
    word_built,
    !.

'take letter and block'  @ letter(L), block((A,B)) <=> L == A ; L == B | true.
'fail if letters remain' @ word_built, letter(_)   <=> false.

%% These rules, removing remaining constraints from the store, are just cosmetic:
'clean up blocks' @ word_built \ block(_) <=> true.
'word was built'  @ word_built            <=> true.
