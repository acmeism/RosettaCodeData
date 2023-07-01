:- initialization(main).

main :-
    open("/dev/lp0", write, Printer),
    writeln(Printer, "Hello, world!"),
    flush_output(Printer),
    close(Printer).
