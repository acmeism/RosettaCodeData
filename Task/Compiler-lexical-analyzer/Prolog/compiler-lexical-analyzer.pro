/*
    Test harness for the analyzer, not needed if we are actually using the output.
*/
load_file(File, Input) :-
	read_file_to_codes(File, Codes, []),
	maplist(char_code, Chars, Codes),
	atom_chars(Input,Chars).

test_file(File) :-
	load_file(File, Input),
	tester(Input).

tester(S) :-
	atom_chars(S,Chars),
	tokenize(Chars,L),
	maplist(print_tok, L),
	!.

print_tok(L) :-
	L =.. [Op,Line,Pos],
	format('~d\t~d\t~p~n', [Line,Pos,Op]).
print_tok(string(Value,Line,Pos)) :-
	format('~d\t~d\tstring\t\t"~w"~n', [Line,Pos,Value]).	
print_tok(identifier(Value,Line,Pos)) :-
	format('~d\t~d\tidentifier\t~p~n', [Line,Pos,Value]).	
print_tok(integer(Value,Line,Pos)) :-
	format('~d\t~d\tinteger\t\t~p~n', [Line,Pos,Value]).	


/*
	Tokenize
	
	run the input over a DCG to get out the tokens.
	
	In - a list of chars to tokenize
	Tokens = a list of tokens (excluding spaces).
*/
tokenize(In,RelTokens) :-
	newline_positions(In,1,NewLines),
	tokenize(In,[0|NewLines],1,1,Tokens),
	check_for_exceptions(Tokens),
	exclude(token_name(space),Tokens,RelTokens).

tokenize([],NewLines,Pos,LineNo,[end_of_input(LineNo,Offset)]) :-
	position_offset(NewLines,Pos,Offset).
tokenize(In,NewLines,Pos,LineNo,Out) :-
	position_offset(NewLines,Pos,Offset),
	phrase(tok(Tok,TokLen,LineNo,Offset),In,T),
	(
		Tok = [] -> Out = Toks
		; Out = [Tok|Toks]
	),
	Pos1 is Pos + TokLen,
	update_line_no(LineNo,NewLines,Pos1,NewLineNo,NewNewLines),
	tokenize(T,NewNewLines,Pos1,NewLineNo,Toks).
	
update_line_no(LNo,[L],_,LNo,[L]).
update_line_no(LNo,[L,Nl|T],Pos,LNo,[L,Nl|T]) :-
	Pos =< Nl.
update_line_no(LNo,[_,Nl|T],Pos,LNo2,Nlines) :-
	Pos > Nl,
	succ(LNo,LNo1),
	update_line_no(LNo1,[Nl|T],Pos,LNo2,Nlines).

position_offset([Line|_],Pos,Offset) :- Offset is Pos - Line.	
	
token_name(Name,Tok) :- functor(Tok,Name,_).	

% Get a list of all the newlines and their position in the data
% This is used to create accurate row/column numbers. 	
newline_positions([],N,[N]).
newline_positions(['\n'|T],N,[N|Nt]) :- succ(N,N1), newline_positions(T,N1,Nt).
newline_positions([C|T],N,Nt) :- dif(C,'\n'), succ(N,N1), newline_positions(T,N1,Nt).	
	
% The tokenizer can tokenize some things that it shouldn't, deal with them here. 	
check_for_exceptions([]). % all ok
check_for_exceptions([op_divide(L,P),op_multiply(_,_)|_]) :-
	format(atom(Error), 'Unclosed comment at line ~d,~d', [L,P]),
	throw(Error).
check_for_exceptions([integer(_,L,P),identifier(_,_,_)|_]) :-
	format(atom(Error), 'Invalid identifier at line ~d,~d', [L,P]),
	throw(Error).	
check_for_exceptions([_|T]) :- check_for_exceptions(T).	


/*
	A set of helper DCGs for the more complicated token types
*/	
:- set_prolog_flag(double_quotes, chars).

identifier(I) --> c_types(I,csym).
identifier(['_']) --> ['_'].
identifier([]) --> [].

integer_(I,L) --> c_types(N,digit), { number_codes(I,N), length(N,L) }.

% get a sequence of characters of the same type (https://www.swi-prolog.org/pldoc/doc_for?object=char_type/2)
c_types([C|T],Type) --> c_type(C,Type), c_types(T,Type).
c_types([C],Type) --> c_type(C,Type).
c_type(C,Type) --> [C],{ char_type(C,Type) }.

anything([]) --> [].
anything([A|T]) --> [A], anything(T).

string_([]) --> [].
string_([A|T]) --> [A], { dif(A,'\n') }, string_(T).


/*
	The token types are all handled by the tok DCG, order of predicates is important here.
*/	
% comment
tok([],CLen,_,_) --> "/*", anything(A), "*/", { length(A,Len), CLen is Len + 4 }.

% toks
tok(op_and(L,P),2,L,P) --> "&&".
tok(op_or(L,P),2,L,P) --> "||".
tok(op_lessequal(L,P),2,L,P) --> "<=".
tok(op_greaterequal(L,P),2,L,P) --> ">=".
tok(op_greaterequal(L,P),2,L,P) --> ">=".
tok(op_equal(L,P),2,L,P) --> "==".
tok(op_notequal(L,P),2,L,P) --> "!=".
tok(op_assign(L,P),1,L,P) --> "=".
tok(op_multiply(L,P),1,L,P) --> "*".
tok(op_divide(L,P),1,L,P) --> "/".
tok(op_mod(L,P),1,L,P) --> "%".
tok(op_add(L,P),1,L,P) --> "+".
tok(op_subtract(L,P),1,L,P) --> "-".
tok(op_negate(L,P),1,L,P) --> "-".
tok(op_less(L,P),1,L,P) --> "<".
tok(op_greater(L,P),1,L,P) --> ">".
tok(op_not(L,P),1,L,P) --> "!".

% symbols
tok(left_paren(L,P),1,L,P) --> "(".
tok(right_paren(L,P),1,L,P) --> ")".
tok(left_brace(L,P),1,L,P) --> "{".
tok(right_brace(L,P),1,L,P) --> "}".
tok(semicolon(L,P),1,L,P) --> ";".
tok(comma(L,P),1,L,P) --> ",".

% keywords
tok(keyword_if(L,P),2,L,P) --> "if".
tok(keyword_else(L,P),4,L,P) --> "else".
tok(keyword_while(L,P),5,L,P) --> "while".
tok(keyword_print(L,P),5,L,P) --> "print".
tok(keyword_putc(L,P),4,L,P) --> "putc".

% identifier and literals
tok(identifier(I,L,P),Len,L,P) --> c_type(S,csymf), identifier(T), { atom_chars(I,[S|T]), length([S|T],Len) }.
tok(integer(V,L,P),Len,L,P) --> integer_(V,Len).
tok(integer(I,L,P),4,L,P) --> "'\\\\'", { char_code('\\', I) }.
tok(integer(I,L,P),4,L,P) --> "'\\n'", { char_code('\n', I) }.
tok(integer(I,L,P),3,L,P) --> ['\''], [C], ['\''], { dif(C,'\n'), dif(C,'\''), char_code(C,I) }.
tok(string(S,L,P),SLen,L,P) --> ['"'], string_(A),['"'], { atom_chars(S,A), length(A,Len), SLen is Len + 2 }.

% spaces
tok(space(L,P),Len,L,P) --> c_types(S,space), { length(S,Len) }.

% anything else is an error
tok(_,_,L,P) --> { format(atom(Error), 'Invalid token at line ~d,~d', [L,P]), throw(Error) }.
