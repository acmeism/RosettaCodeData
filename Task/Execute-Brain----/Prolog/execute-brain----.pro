/******************************************
 Starting point, call with program in atom.
*******************************************/
brain(Program) :-
	atom_chars(Program, Instructions),
	process_bf_chars(Instructions).

brain_from_file(File) :- % or from file...
	read_file_to_codes(File, Codes, []),
	maplist(char_code, Instructions, Codes),
	process_bf_chars(Instructions).

process_bf_chars(Instructions)	:-
	phrase(bf_to_pl(Code), Instructions, []),
	Code = [C|_],
	instruction(C, Code, mem([], [0])), !.


/********************************************
 DCG to parse the bf program into prolog form
*********************************************/
bf_to_pl([]) --> [].
bf_to_pl([loop(Ins)|Next]) --> loop_start, bf_to_pl(Ins), loop_end, bf_to_pl(Next).
bf_to_pl([Ins|Next]) --> bf_code(Ins), bf_to_pl(Next).
bf_to_pl(Ins) --> [X], { \+ member(X, ['[',']',>,<,+,-,'.',',']) }, bf_to_pl(Ins). % skip non bf characters

loop_start --> ['['].
loop_end --> [']'].

bf_code(next_addr) --> ['>'].
bf_code(prev_addr) --> ['<'].
bf_code(inc_caddr) --> ['+'].
bf_code(dec_caddr) --> ['-'].
bf_code(out_caddr) --> ['.'].
bf_code(in_caddr)  --> [','].

/**********************
  Instruction Processor
***********************/
instruction([], _, _).
instruction(I, Code, Mem) :-
	mem_instruction(I, Mem, UpdatedMem),
	next_instruction(Code, NextI, NextCode),
	!, % cuts are to force tail recursion, so big programs will run
	instruction(NextI, NextCode, UpdatedMem).

% to loop, add the loop code to the start of the program then execute
% when the loop has finished it will reach itself again then can retest for zero
instruction(loop(LoopCode), Code, Mem) :-
	caddr(Mem, X),
	dif(X, 0),
	append(LoopCode, Code, [NextI|NextLoopCode]),
	!,
	instruction(NextI, [NextI|NextLoopCode], Mem).
instruction(loop(_), Code, Mem) :-
	caddr(Mem, 0),
	next_instruction(Code, NextI, NextCode),
	!,
	instruction(NextI, NextCode, Mem).

% memory is stored in two parts:
%   1. a list with the current address and everything after it
%   2. a list with the previous memory in reverse order
mem_instruction(next_addr, mem(Mb, [Caddr]), mem([Caddr|Mb], [0])).
mem_instruction(next_addr, mem(Mb, [Caddr,NextAddr|Rest]), mem([Caddr|Mb], [NextAddr|Rest])).
mem_instruction(prev_addr, mem([PrevAddr|RestOfPrev], Caddrs), mem(RestOfPrev, [PrevAddr|Caddrs])).

% wrap instructions at the byte boundaries as this is what most programmers expect to happen
mem_instruction(inc_caddr, MemIn, MemOut) :- caddr(MemIn, 255), update_caddr(MemIn, 0, MemOut).
mem_instruction(inc_caddr, MemIn, MemOut) :- caddr(MemIn, Val), succ(Val, IncVal), update_caddr(MemIn, IncVal, MemOut).
mem_instruction(dec_caddr, MemIn, MemOut) :- caddr(MemIn, 0), update_caddr(MemIn, 255, MemOut).
mem_instruction(dec_caddr, MemIn, MemOut) :- caddr(MemIn, Val), succ(DecVal, Val), update_caddr(MemIn, DecVal, MemOut).

% input and output
mem_instruction(out_caddr, Mem, Mem) :- caddr(Mem, Val), char_code(Char, Val), write(Char).
mem_instruction(in_caddr, MemIn, MemOut) :-
	get_single_char(Code),
	char_code(Char, Code),
	write(Char),
	map_input_code(Code,MappedCode),
	update_caddr(MemIn, MappedCode, MemOut).

% need to map the newline if it is not a proper newline character (system dependent).
map_input_code(13,10) :- nl.
map_input_code(C,C).

% The value at the current address
caddr(mem(_, [Caddr]), Caddr).
caddr(mem(_, [Caddr,_|_]), Caddr).

% The updated value at the current address
update_caddr(mem(BackMem, [_]), Caddr, mem(BackMem, [Caddr])).
update_caddr(mem(BackMem, [_,M|Mem]), Caddr, mem(BackMem, [Caddr,M|Mem])).

% The next instruction, and remaining code
next_instruction([_], [], []).
next_instruction([_,NextI|Rest], NextI, [NextI|Rest]).
