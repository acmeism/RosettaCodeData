csv_html_plus :-
	L =
"Character,Speech
The multitude,The messiah! Show us the messiah!
Brians mother,<angry>Now you listen here! He's not the messiah; he's a very naughty boy! Now go away!</angry>
The multitude,Who are you?
Brians mother,I'm his mother; that's who!
The multitude,Behold his mother! Behold his mother!",

	csv_html_plus(L, Out1, []),
	string_to_list(Str1, Out1),
	writeln(Str1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HTML +
%
csv_html_plus(L) -->
	"<TABLE>\n",
	csv_head(L, R),
	csv_body(R),
	"</TABLE>".


csv_head(L, R) -->
	"<THEAD>\n",
	csv_head_tr(L, R),
	"</THEAD>\n".


csv_head_tr(L, R) -->
	"<TR>\n",
	csv_head_th(L, R),
	"\n</TR>\n".


csv_head_th(L, S) -->
	"<TH style='color:#000; background:#FF0;'>",
	csv_head_th_in(L, S),
	"</TH>".

csv_head_th_in([], []) --> [].

csv_head_th_in([10|L], L) --> [].

csv_head_th_in([44|L], S) -->
	"</TH><TH style='color:#000; background:#FF0;'>",
	csv_head_th_in(L,S).

csv_head_th_in([H|T], S) -->
	[H],
	csv_head_th_in(T, S).


csv_body(L) -->
	"<TBODY>\n",
	csv_body_tr(L),
	"</TBODY>\n".

csv_body_tr([]) --> [].

csv_body_tr(L) -->
	"<TR>\n",
	csv_body_td(L, S),
	"\n</TR>\n",
	csv_body_tr(S).

csv_body_td(L, S) -->
	"<TD  style='color:#000; background:#8FF; border:1px #000 solid; padding:0.6em;'>",
	csv_body_td_in(L, S),
	"</TD>".

csv_body_td_in([], []) --> [].

csv_body_td_in([10|L], L) --> [].

csv_body_td_in([44|L], S) -->
	"</TD><TD  style='color:#000; background:#8FF; border:1px #000 solid; padding:0.6em;'>",
	csv_body_td_in(L,S).

csv_body_td_in([60|T], S) -->
	"&lt;",
	csv_body_td_in(T, S).

csv_body_td_in([62|T], S) -->
	"&gt;",
	csv_body_td_in(T, S).

csv_body_td_in([H|T], S) -->
	[H],
	csv_body_td_in(T, S).
