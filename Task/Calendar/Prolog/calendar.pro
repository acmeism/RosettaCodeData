% Write out the calender, because format can actually span multiple lines, it is easier
% to write out the static parts in place and insert the generated parts into that format.
write_calendar(Year) :-
	month_x3_format(Year, 1, 2, 3, F1_3),
	month_x3_format(Year, 4, 5, 6, F4_6),
	month_x3_format(Year, 7, 8, 9, F7_9),
	month_x3_format(Year, 10, 11, 12, F10_12),
	
	format('

                                      ~w

            January                  February                   March
      Su Mo Tu We Th Fr Sa     Su Mo Tu We Th Fr Sa     Su Mo Tu We Th Fr Sa
~w

             April                     May                      June
      Su Mo Tu We Th Fr Sa     Su Mo Tu We Th Fr Sa     Su Mo Tu We Th Fr Sa
~w

              July                    August                  September
      Su Mo Tu We Th Fr Sa     Su Mo Tu We Th Fr Sa     Su Mo Tu We Th Fr Sa
~w

            October                  November                 December
      Su Mo Tu We Th Fr Sa     Su Mo Tu We Th Fr Sa     Su Mo Tu We Th Fr Sa
~w	
', [Year, F1_3, F4_6, F7_9, F10_12]), !.

% Generate the data for a row of months and then create an atom one row at a time
% for all of the months.
month_x3_format(Year, M1, M2, M3, F) :-
	calc_month_rows(Year, M1, M1r),
	calc_month_rows(Year, M2, M2r),
	calc_month_rows(Year, M3, M3r),
	month_x3_format(M1r, M2r, M3r, F).
	
month_x3_format(M1, M2, M3, '') :- maplist(=('   '), M1), maplist(=('   '), M2), maplist(=('   '), M3).
month_x3_format(M1, M2, M3, F) :-
		month_format('      ', M1, M1r, F1),
		month_format(F1, M2, M2r, F2),
		month_format(F2, M3, M3r, F3),
		atom_concat(F3, '\n', F4),
		month_x3_format(M1r, M2r, M3r, Fr),
		atom_concat(F4, Fr, F).
	
month_format(Orig, [Su,Mo,Tu,We,Th,Fr,Sa|R], R, F) :-
	maplist(day_format, [Su,Mo,Tu,We,Th,Fr,Sa], Formatted),
	format(atom(F2), '~w~w~w~w~w~w~w    ', Formatted),
	atom_concat(Orig, F2, F).

day_format('   ', '   ') :- !.
day_format(D, F) :- D < 10, format(atom(F), '~w  ', D).
day_format(D, F) :- D >= 10, format(atom(F), '~w ', D).

% Calculate the days of a month, this is done by getting the first day of the month,
% then offsetting that with spaces from the start and then adding 1-NumDaysinMonth and
% finally spaces until the end. The maximum possible size is used and then truncated later.
calc_month_rows(Year, Month, Result) :-
	length(Result, 42), % max 6 rows of 7 days
	month_days(Month, Year, DaysInMonth),
	day_of_the_week(date(Year, Month, 1), FirstWeekDay),
	day_offset(FirstWeekDay, Offset),
	day_print_map(DaysInMonth, Offset, Result).

day_print_map(DaysInMonth, 0, [1|R]) :-	
	day_print_map2(DaysInMonth, 2, R).	
day_print_map(DaysInMonth, Offset, ['   '|R]) :-
	dif(Offset, 0),
	succ(NewOffset, Offset),
	day_print_map(DaysInMonth, NewOffset, R).

day_print_map2(D, D, [D|R])	:- day_print_map(R).
day_print_map2(D, N, [N|R]) :- dif(D,N), succ(N, N1), day_print_map2(D, N1, R).

day_print_map([]).
day_print_map(['   '|R]) :- day_print_map(R).

% Figure out the number of days in a month based on whether it is a leap year or not.
month_days(2, Year, Days) :-
	is_leap_year(Year) -> Days = 29
	; Days = 28.
month_days(Month, _, Days) :-
	dif(Month, 2),
	nth1(Month, [31, _, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31], Days).

% Figure out the space offset based on the day the month starts on.
day_offset(D, D) :- dif(D, 7).
day_offset(7, 0).

% Test for leap years
is_leap_year(Year) :-
	0 is Year mod 100 -> 0 is Year mod 400
	; 0 is Year mod 4.
