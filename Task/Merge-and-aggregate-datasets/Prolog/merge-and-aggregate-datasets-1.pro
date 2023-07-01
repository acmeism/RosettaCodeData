patient(1001,'Hopper').
patient(4004,'Wirth').
patient(3003,'Kemeny').
patient(2002,'Gosling').
patient(5005,'Kurtz').

visit(2002,'2020-09-10',6.8).
visit(1001,'2020-09-17',5.5).
visit(4004,'2020-09-24',8.4).
visit(2002,'2020-10-08',nan).
visit(1001,'',6.6).
visit(3003,'2020-11-12',nan).
visit(4004,'2020-11-05',7.0).
visit(1001,'2020-11-19',5.3).

summaryDates(Id, Lastname, LastDate) :-
     aggregate(max(Ts),
	       Score^Date^(visit(Id, Date, Score), Date \= '', parse_time(Date, iso_8601, Ts)),
	       MaxTs),
     format_time(atom(LastDate), '%Y-%m-%d', MaxTs),
     patient(Id,Lastname).

summaryScores(Id, Lastname, Sum, Mean) :-
     aggregate(r(sum(Score),count), Date^(visit(Id, Date, Score), Score \= nan), r(Sum,Count)),
     patient(Id,Lastname),
     Mean is Sum/Count.

test :-
    summaryDates(Id, Lastname, LastDate),
    writeln(summaryDates(Id, Lastname, LastDate)),
    fail.

test :-
    summaryScores(Id, Lastname, ScoreSum, ScoreMean),
    writeln(summaryScores(Id, Lastname, ScoreSum, ScoreMean)),
    fail.
