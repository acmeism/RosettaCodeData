:- object(blocks_test).

    :- public(run/0).

    :- uses(logtalk, [print_message(information, blocks, Message) as print(Message)]).

    run :-
        block_set(BlockSet),
        word_list(WordList),
        blocks(BlockSet)::spell_no_spell(WordList, S, U),
        print('The following words can be spelled by this block set'::S),
        print('The following words cannot be spelled by this block set'::U).

    % test configuration data

    block_set([b(b,o), b(x,k), b(d,q), b(c,p), b(n,a),
        b(g,t), b(r,e), b(t,g), b(q,d), b(f,s),
        b(j,w), b(h,u), b(v,i), b(a,n), b(o,b),
        b(e,r), b(f,s), b(l,y), b(p,c), b(z,m)]).

    word_list(['', 'A', 'bark', 'bOOk', 'treAT', 'COmmon', 'sQuaD', 'CONFUSE']).

:- end_object.
