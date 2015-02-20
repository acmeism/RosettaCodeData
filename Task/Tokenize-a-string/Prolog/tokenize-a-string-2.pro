?- split_string("Hello,How,Are,You,Today", ",", "", Split),
|    atomics_to_string(Split, ".", PeriodSeparated),
|    writeln(PeriodSeparated).
Hello.How.Are.You.Today
