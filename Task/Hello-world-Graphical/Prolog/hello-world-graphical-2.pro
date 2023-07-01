goodbye :-
    new(D, window('Goodbye')),
    send(D, size, size(250, 100)),
    new(S, string("Goodbye, World !")),
    new(T, text(S)),
    get(@display, label_font, F),
    get(F, width(S), M),
    XT is (250 - M)/2,
    get(F, height, H),
    YT = (100-H)/2,
    send(D, display, T, point(XT, YT)),
    send(D, open).
