turing(Config, Rules, TapeIn, TapeOut) :-
    call(Config, IS, _, _, _, _),
    perform(Config, Rules, IS, {[], TapeIn}, {Ls, Rs}),
    reverse(Ls, Ls1),
    append(Ls1, Rs, TapeOut).

perform(Config, Rules, State, TapeIn, TapeOut) :-
    call(Config, _, FS, RS, B, Symbols),
    ( memberchk(State, FS) ->
        TapeOut = TapeIn
    ; memberchk(State, RS) ->
        {LeftIn, RightIn} = TapeIn,
        symbol(RightIn, Symbol, RightRem, B),
        memberchk(Symbol, Symbols),
        once(call(Rules, State, Symbol, NewSymbol, Action, NewState)),
        memberchk(NewSymbol, Symbols),
        action(Action, {LeftIn, [NewSymbol|RightRem]}, {LeftOut, RightOut}, B),
        perform(Config, Rules, NewState, {LeftOut, RightOut}, TapeOut) ).

symbol([],       B,   [], B).
symbol([Sym|Rs], Sym, Rs, _).

action(left,  {Lin, Rin},  {Lout, Rout}, B) :- left(Lin, Rin, Lout, Rout, B).
action(stay,  Tape,        Tape,         _).
action(right, {Lin, Rin},  {Lout, Rout}, B) :- right(Lin, Rin, Lout, Rout, B).

left([],     Rs, [], [B|Rs], B).
left([L|Ls], Rs, Ls, [L|Rs], _).

right(L, [],     [B|L], [], B).
right(L, [S|Rs], [S|L], Rs, _).
