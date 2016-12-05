day(1, 'first').
day(2, 'second').
day(3, 'third').
day(4, 'fourth').
day(5, 'fifth').
day(6, 'sixth').
day(7, 'seventh').
day(8, 'eighth').
day(9, 'ninth').
day(10, 'tenth').
day(11, 'eleventh').
day(12, 'twelfth').

gift(1, 'A partridge in a pear tree.').
gift(2, 'Two turtle doves and').
gift(3, 'Three French hens,').
gift(4, 'Four calling birds,').
gift(5, 'Five gold rings,').
gift(6, 'Six geese a-laying,').
gift(7, 'Seven swans a-swimming,').
gift(8, 'Eight maids a-milking,').
gift(9, 'Nine ladies dancing,').
gift(10, 'Ten lords a-leaping,').
gift(11, 'Eleven pipers piping,').
gift(12, 'Twelve drummers drumming,').

giftsFor(0, []) :- !.
giftsFor(N, [H|T]) :- gift(N, H), M is N-1, giftsFor(M,T).

writeln(S) :- write(S), write('\n').

writeList([])    :- writeln(''), !.
writeList([H|T]) :- writeln(H), writeList(T).

writeGifts(N) :- day(N, Nth), write('On the '), write(Nth),
    writeln(' day of Christmas, my true love sent to me:'),
    giftsFor(N,L), writeList(L).

writeLoop(0) :- !.
writeLoop(N) :- Day is 13 - N, writeGifts(Day), M is N - 1, writeLoop(M).

main :- writeLoop(12), halt.
