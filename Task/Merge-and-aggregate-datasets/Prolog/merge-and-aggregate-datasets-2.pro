:- import bagMax/2, bagCount/2, bagSum/2, bagReduce/4 from aggregs.
:- import julian_date/7, date_string/3 from iso8601.
:- import load_csv/2, add_cvt_type_hook/2 from proc_files.

?- add_cvt_type_hook(date,date_converter(_,_)).

date_converter(Atom,Date) :- date_string('YYYY-MM-DD',Date,Atom).

:- load_csv('visit.csv',visit(integer,date,float)).
:- load_csv('patient.csv',patient(integer,atom)).

is_nan(Number) :- X is Number, X =\= Number.

summaryDates(Id, Lastname, LastDate) :-
    bagMax(date_number(Id), LastDateNumber),
    patient(Id,Lastname),
    julian_date(LastDateNumber, Y, M, D, _, _, _),
    date_converter(LastDate, date(Y,M,D)).

summaryScores(Id, Lastname, Sum, Mean) :-
    bagSum(scores(Id), Sum),
    bagCount(scores(Id), Count),
    Mean is Sum/Count,
    patient(Id,Lastname).

test :-
    summaryDates(Id,Lastname,LastDate),
    writeln(summaryDates(Id,Lastname,LastDate)), fail.

test :-
    summaryScores(Id, Lastname, ScoreSum, ScoreMean),
    writeln(summaryScores(Id, Lastname, ScoreSum, ScoreMean)), fail.

/* Put hilog declarations together */

date_number(Id)(Number) :-
    visit(Id, date(Y,M,D), _),
    julian_date(Number, Y, M, D, _, _, _).
		
scores(Id)(Score) :-
    visit(Id, _, Score),
    \+is_nan(Score).

:- hilog maximum.
maximum(X,Y,Z) :- X @> Y -> Z=X ; Z=Y.
:- hilog sum.
sum(X,Y,Z) :- Z is X+Y.
:- hilog successor.
successor(X,_Y,Z) :- Z is X+1.
