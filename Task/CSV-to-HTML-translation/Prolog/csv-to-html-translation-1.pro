csv_html :-
	L = "Character,Speech
The multitude,The messiah! Show us the messiah!
Brians mother,<angry>Now you listen here! He's not the messiah; he's a very naughty boy! Now go away!</angry>
The multitude,Who are you?
Brians mother,I'm his mother; that's who!
The multitude,Behold his mother! Behold his mother!",

	csv_html(L, Out, []),
	string_to_list(Str, Out),
	writeln(Str).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% simple HTML
%
csv_html(L) -->
	"<TABLE>\n",
	csv_tr(L),
	"</TABLE>".

csv_tr([]) --> [].

csv_tr(L) -->
	"<TR>\n",
	csv_td(L, S),
	"\n</TR>\n",
	csv_tr(S).

csv_td(L, S) -->
	"<TD>",
	csv_td_in(L, S),
	"</TD>".

csv_td_in([], []) --> [].

csv_td_in([10|L], L) --> [].

csv_td_in([44|L], S) -->
	"</TD><TD>",
	csv_td_in(L,S).

csv_td_in([60|T], S) -->
	"&lt;",
	csv_td_in(T, S).

csv_td_in([62|T], S) -->
	"&gt;",
	csv_td_in(T, S).

csv_td_in([H|T], S) -->
	[H],
	csv_td_in(T, S).
