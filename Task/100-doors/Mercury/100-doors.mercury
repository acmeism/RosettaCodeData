:- module doors.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- implementation.
:- import_module bitmap, bool, list, string, int.

:- func doors = bitmap.
doors = bitmap.init(100, no).

:- pred walk(int, bitmap, bitmap).
:- mode walk(in, bitmap_di, bitmap_uo) is det.
walk(Pass, !Doors) :-
    walk(Pass, Pass, !Doors).

:- pred walk(int, int, bitmap, bitmap).
:- mode walk(in, in, bitmap_di, bitmap_uo) is det.
walk(At, By, !Doors) :-
    ( if bitmap.in_range(!.Doors, At - 1) then
        bitmap.unsafe_flip(At - 1, !Doors),
        walk(At + By, By, !Doors)
    else
        true
    ).

:- pred report(bitmap, int, io, io).
:- mode report(bitmap_di, in, di, uo) is det.
report(Doors, N, !IO) :-
    ( if is_set(Doors, N - 1) then
        State = "open"
    else
        State = "closed"
    ),
    io.format("door #%d is %s\n",
        [i(N), s(State)], !IO).

main(!IO) :-
    list.foldl(walk, 1 .. 100, doors, Doors),
    list.foldl(report(Doors), 1 .. 100, !IO).
